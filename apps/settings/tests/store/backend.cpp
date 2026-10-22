#include "AppStore.h"
#include <QCryptographicHash>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QJsonDocument>
#include <QStandardPaths>
#include <QTemporaryDir>
#include <QtTest>

// Only synthetic installers are executed. Run these tests in a disposable VM.
class AppStoreTest : public QObject {
    Q_OBJECT
    QTemporaryDir temporary;
    QByteArray oldData, oldCache, oldRoot, oldState;
    const QString revision = QString(40, 'a');
    QString cache;
    QString root;

    static void write(const QString& path, const QByteArray& bytes)
    {
        QVERIFY(QDir().mkpath(QFileInfo(path).absolutePath()));
        QFile file(path);
        QVERIFY(file.open(QIODevice::WriteOnly));
        QCOMPARE(file.write(bytes), bytes.size());
    }
    void prepare(const QByteArray& installBody)
    {
        const QByteArray prefix =
            "#!/bin/sh\n"
            "result() { printf '{\"schemaVersion\":1,\"type\":\"result\",\"appId\":\"org.nextkde.KMusic\",\"action\":\"%s\",%s}\\n' \"$1\" \"$2\"; }\n"
            "case \"$1\" in\n"
            "check) result check '\"success\":true,\"code\":\"OK\"';;\n"
            "uninstall) rm -rf \"$KOS_STORE_TEST_ROOT\"; result uninstall '\"success\":true,\"code\":\"OK\"';;\n"
            "status) if [ -f \"$KOS_STORE_TEST_ROOT/current/bin/kmusic\" ]; then installed=true; else installed=false; fi; "
            "result status \"\\\"success\\\":true,\\\"code\\\":\\\"OK\\\",\\\"installed\\\":$installed\";;\n"
            "install)\n";
        const QByteArray script = prefix + installBody + "\n;;\nesac\n";
        const QByteArray implementation = "# synthetic installer fixture\n";
        QJsonObject hashes;
        hashes["install.sh"] = QString::fromLatin1(QCryptographicHash::hash(script, QCryptographicHash::Sha256).toHex());
        hashes["packaging/installer.py"] = QString::fromLatin1(QCryptographicHash::hash(implementation, QCryptographicHash::Sha256).toHex());
        QJsonObject release{{"revision", revision}, {"sha256", hashes}};
        QJsonObject entry{{"appId", "org.nextkde.KMusic"}, {"repository", "https://github.com/NextKde/KMusic"}, {"release", release}};
        write(temporary.path() + "/app-store/catalog.json", QJsonDocument(QJsonObject{{"schemaVersion", 1}, {"kmusic", entry}}).toJson());
        write(cache + "/install.sh", script);
        write(cache + "/packaging/installer.py", implementation);
    }
    QByteArray successBody() const
    {
        return "mkdir -p \"$KOS_STORE_TEST_ROOT/current/bin\"\n"
            "printf '#!/bin/sh\\nexit 0\\n' > \"$KOS_STORE_TEST_ROOT/current/bin/kmusic\"\n"
            "chmod +x \"$KOS_STORE_TEST_ROOT/current/bin/kmusic\"\n"
            "printf '{\"appId\":\"org.nextkde.KMusic\",\"version\":\"" + revision.toUtf8()
            + "\"}' > \"$KOS_STORE_TEST_ROOT/manifest.json\"\n"
            "result install '\"success\":true,\"code\":\"INSTALLED\",\"version\":\"" + revision.toUtf8() + "\"'\n";
    }
private slots:
    void init()
    {
        QVERIFY(temporary.isValid());
        oldData = qgetenv("XDG_DATA_HOME");
        oldCache = qgetenv("XDG_CACHE_HOME");
        oldRoot = qgetenv("KOS_STORE_TEST_ROOT");
        oldState = qgetenv("XDG_STATE_HOME");
        qputenv("XDG_STATE_HOME", (temporary.path() + "/state").toUtf8());
        qputenv("XDG_DATA_HOME", (temporary.path() + "/data").toUtf8());
        qputenv("XDG_CACHE_HOME", (temporary.path() + "/cache").toUtf8());
        root = QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation) + "/kmusic-app";
        qputenv("KOS_STORE_TEST_ROOT", root.toUtf8());
        cache = QStandardPaths::writableLocation(QStandardPaths::CacheLocation) + "/installers/KMusic/" + revision;
    }
    void cleanup()
    {
        QDir(temporary.path() + "/data").removeRecursively();
        QDir(temporary.path() + "/cache").removeRecursively();
        QDir(temporary.path() + "/app-store").removeRecursively();
        auto restore = [](const char* name, const QByteArray& value) {
            if (value.isNull()) qunsetenv(name); else qputenv(name, value);
        };
        restore("XDG_DATA_HOME", oldData);
        restore("XDG_CACHE_HOME", oldCache);
        restore("KOS_STORE_TEST_ROOT", oldRoot);
        restore("XDG_STATE_HOME", oldState);
    }
    void unpublishedCatalogueCannotInstall()
    {
        AppStore store(temporary.path());
        QVERIFY(!store.music().value("available").toBool());
        store.install();
        QCOMPARE(store.music().value("code").toString(), "RELEASE_UNAVAILABLE");
        QVERIFY(!store.music().value("busy").toBool());
    }
    void installAndUninstall()
    {
        prepare(successBody());
        AppStore store(temporary.path());
        store.install();
        QTRY_VERIFY_WITH_TIMEOUT(!store.music().value("busy").toBool(), 5000);
        QCOMPARE(store.music().value("code").toString(), "");
        QVERIFY(store.music().value("installed").toBool());
        store.uninstall();
        QTRY_VERIFY_WITH_TIMEOUT(!store.music().value("busy").toBool(), 5000);
        QCOMPARE(store.music().value("code").toString(), "");
        QVERIFY(!store.music().value("installed").toBool());
    }
    void malformedResult_data()
    {
        QTest::addColumn<QByteArray>("body");
        QTest::newRow("no-result") << QByteArray("exit 0");
        QTest::newRow("nonzero-success") << (successBody() + "exit 1\n");
        QTest::newRow("duplicate") << (successBody() + successBody());
        QTest::newRow("invalid-json") << QByteArray("printf 'not json\\n'");
        QTest::newRow("wrong-app") << QByteArray("printf '{\"schemaVersion\":1,\"type\":\"result\",\"appId\":\"other\",\"action\":\"install\",\"success\":true,\"code\":\"INSTALLED\"}\\n'");
    }
    void malformedResult()
    {
        QFETCH(QByteArray, body);
        prepare(body);
        AppStore store(temporary.path());
        store.install();
        QTRY_VERIFY_WITH_TIMEOUT(!store.music().value("busy").toBool(), 5000);
        QCOMPARE(store.music().value("code").toString(), "RESULT_UNKNOWN");
    }
    void dependencyFailure()
    {
        prepare("result install '\"success\":false,\"code\":\"DEPENDENCY_UNSATISFIED\",\"details\":{\"dependencies\":[{\"id\":\"taglib\",\"required\":\">=1.12\"}]}'\nexit 11");
        AppStore store(temporary.path());
        store.install();
        QTRY_VERIFY_WITH_TIMEOUT(!store.music().value("busy").toBool(), 5000);
        QCOMPARE(store.music().value("code").toString(), "DEPENDENCY_UNSATISFIED");
        QCOMPARE(store.music().value("dependencies").toList().size(), 1);
    }
    void cancellationAndConcurrentClick()
    {
        prepare("sleep 30\n" + successBody());
        AppStore store(temporary.path());
        store.install();
        QTRY_COMPARE_WITH_TIMEOUT(store.music().value("stage").toString(), "install", 5000);
        store.uninstall(); // ignored while installing
        QVERIFY(store.music().value("busy").toBool());
        store.cancel();
        QTRY_VERIFY_WITH_TIMEOUT(!store.music().value("busy").toBool(), 12000);
        QCOMPARE(store.music().value("code").toString(), "RESULT_UNKNOWN");
        QVERIFY(!store.music().value("installed").toBool());
    }
};
QTEST_GUILESS_MAIN(AppStoreTest)
#include "backend.moc"
