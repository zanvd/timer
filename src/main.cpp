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
#include "src/ConsoleDebug/Console.hpp"
#include "src/ConsoleDebug/ConsoleDebugSettings.hpp"

#include "Settings.hpp"

#include <bb/cascades/Application>

#include <QLocale>
#include <QTranslator>

#include <Qt/qdeclarativedebug.h>

using namespace bb::cascades;

void myMessageOutput(QtMsgType type, const char* msg) {
    Q_UNUSED(type);
    fprintf(stdout, "%s\n", msg);
    fflush(stdout);

    ConsoleDebugSettings* consoleDebugSettings = new ConsoleDebugSettings();
    if (consoleDebugSettings -> value("sendToConsoleDebug", false).toBool()) {
        Console* console = new Console();
        console -> sendMessage("ConsoleThis$$" + QString(msg));
        console -> deleteLater();

    }
}

Q_DECL_EXPORT int main(int argc, char **argv)
{
    Application app(argc, argv);

    qInstallMsgHandler(myMessageOutput);

    // Create the Application UI object, this is where the main.qml file
    // is loaded and the application scene is set.
    ApplicationUI appui;

    // Enter the application main event loop.
    return Application::exec();
}
