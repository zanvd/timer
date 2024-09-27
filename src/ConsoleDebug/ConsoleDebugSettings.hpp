/*
 * ConsoleDebugSettings.hpp
 *
 *  Created on: 4. dec. 2014
 *      Author: DesktopPC
 */

#ifndef CONSOLEDEBUGSETTINGS_HPP_
#define CONSOLEDEBUGSETTINGS_HPP_

#include <bb/data/JsonDataAccess>

#define SETTINGS_FILE "data/settings.json"
#define SETTINGS_ERROR "ERROR IN KEY NAME"

class ConsoleDebugSettings
{
public:
    ConsoleDebugSettings();
    virtual ~ConsoleDebugSettings();

    QVariant value(const QString & key, const QVariant & dafualtValue = QVariant());

private:
    bb::data::JsonDataAccess jda;
    QVariantMap settings;
};

#endif /* CONSOLEDEBUGSETTINGS_HPP_ */
