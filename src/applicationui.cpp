/*
 * Copyright (c) 2011-2014 BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "applicationui.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/cascades/LocaleHandler>

#include <bb/cascades/SceneCover>
#include <bb/cascades/AbstractCover>

#include <QTimer>

using namespace bb::cascades;

ApplicationUI::ApplicationUI() :
        QObject(),
        designUnits(new DesignUnits()),
        settings(new Settings(this))
{
    qDebug() << Application::applicationName() << "is initiating...";

    // prepare the localization
    m_pTranslator = new QTranslator(this);
    m_pLocaleHandler = new LocaleHandler(this);

    bool res = QObject::connect(m_pLocaleHandler, SIGNAL(systemLanguageChanged()), this, SLOT(onSystemLanguageChanged()));
    // This is only available in Debug builds
    Q_ASSERT(res);
    // Since the variable is not used in the app, this is added to avoid a
    // compiler warning
    Q_UNUSED(res);

    // initial load
    onSystemLanguageChanged();

    qDebug() <<"Registering QTimer for QML";
    qmlRegisterType<QTimer>("bb.cascades", 1, 2, "Timer");
    qmlRegisterType<SceneCover>("bb.cascades", 1, 2, "SceneCover");
    qmlRegisterUncreatableType<AbstractCover>("bb.cascades", 1, 2, "AbstractCover", "");

    // Create scene document from main.qml asset, the parent is set
    // to ensure the document gets destroyed properly at shut down.
    qDebug() << "Creating QML main screen";
    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);
    qml -> setContextProperty("_app", this);
    qml -> setContextProperty("_ui", designUnits);
    qml -> setContextProperty("_settings", settings);

    /*/Build the path, add it as a context property, and expose it to QML.
    const QString workingDir = QDir::currentPath();
    const QString dirPaths = QString::fromLatin1("file://%1/app/public/").arg(workingDir);
    qml -> documentContext() -> setContextProperty("_publicDir", dirPaths);*/

    // Create root object for the UI
    AbstractPane *root = qml->createRootObject<AbstractPane>();

    // Set created root object as the application scene
    Application::instance()->setScene(root);

    addApplicationCover();

}

void ApplicationUI::onSystemLanguageChanged()
{
    QCoreApplication::instance()->removeTranslator(m_pTranslator);
    // Initiate, load and install the application translation files.
    QString locale_string = QLocale().name();
    QString file_name = QString("Timer_%1").arg(locale_string);
    if (m_pTranslator->load(file_name, "app/native/qm")) {
        QCoreApplication::instance()->installTranslator(m_pTranslator);
    }
}

void ApplicationUI::addApplicationCover()
{
    qDebug() << "Creating QML active frame";
    QmlDocument *qmlCover = QmlDocument::create("asset:///cover/AppCover.qml").parent(this);
    qmlCover->setContextProperty("_app", this);
    qmlCover->setContextProperty("_ui", designUnits);
    qmlCover->setContextProperty("_settings", settings);

    if (!qmlCover -> hasErrors()) {
        AbstractCover* cover = qmlCover->createRootObject<SceneCover>();

        Application::instance() -> setCover(cover);
    }
}
