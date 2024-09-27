/*
 * Settings.cpp
 *
 *  Created on: 21. nov. 2014
 *      Author: DesktopPC
 */

/*
 * Add to Pro:
 * LIBS += -lbbdata
 *
 * This is a custom object that can be used as a basic alternative to QSettings.
 * It stores everything in a JSON file. This can be helpful for performance as
 * JSON is faster than QSettings in most case, and even in Ekke's tests, JSON was
 * the best choice between JSON, XML and SQL.
 */

#include "Settings.hpp"
#include <QFile>

Settings::Settings(QObject * _parent)
{
    //Avoid console warning as this variable is not used.
    Q_UNUSED(_parent);

    //Load the settings file on startup.
    sync();

    //If the settings file doesn't exist, create it.
    QFile jsonFile(SETTINGS_FILE);
    if (!jsonFile.exists())
        save();

    //Watcher for changes in the settings file.
    watcher = new QFileSystemWatcher(this);

    //Listen for any change to the settings file, change this file can occure if another
    //instance is modifying the file (ie: headless or UI).
    watcher -> addPath(SETTINGS_FILE);
    connect(watcher, SIGNAL(fileChanged(QString)), this, SLOT(settingsChanged(QString)));
}

Settings::~Settings()
{
    //Save the settings file on the exit.
    save();
}

void Settings::settingsChanged(const QString & path)
{
    //Avoid console warning as this variable is not used.
    Q_UNUSED(path);

    //Load the settings file, because another instance
    //has modified the file (headless or UI).
    sync();

    qDebug() << "UI: Settings file has changed and is now updated.";
}

QStringList Settings::allKeys()
{
    //Returns a list containing all the key in the map in ascending order.
    return settings.keys();
}

void Settings::clear()
{
    //Removes all items from the settings file.
    settings.clear();
    save();
}

bool Settings::contains(const QString & key)
{
    //Returns true if the settings file contains an item with key key,
    //otherwise returns false.
    return settings.contains(key);
}

QString Settings::fileName()
{
    return SETTINGS_FILE;
}

int Settings::remove(const QString & key)
{
    //Removes all the items that have the key key from the settings file.
    //Return the number of items removed which is usually 1 but will be 0
    // if the key isn't in the settings file.

    return settings.remove(key);
}

void Settings::save()
{
    jda.save(QVariant(settings), SETTINGS_FILE);
}

void Settings::setValue(const QString & key, const QVariant & value)
{
    //Insert a new item with the key key and a value of value.
    //If there is already an item with the key key, that item's values
    //is replaced with value.

    qDebug() << "Settings::setValue ->" << key << ":" << value;

    settings.insert(key, value);
    save();
}

void Settings::sync()
{
    //Reloads any settings that have been changed by another application.
    //This function is called automatically by the event loop at regular interval,
    //so you normally don't need to call it yourself.

    settings = jda.load(SETTINGS_FILE).toMap();
}

QVariant Settings::value(const QString & key, const QVariant & defaultValue)
{
    //Returns the value associated with the key key.
    //If the settings file contains no item with key key,
    //the function returns defaultValue.

    //Return an empty key.
    if (key.trimmed().isEmpty())
        return QVariant();

    if (settings.contains(key)) {
        qDebug() << "Settings::value ->" << key << ":" << settings.value(key);
        return settings.value(key);
    }
    else
        return defaultValue;
}
