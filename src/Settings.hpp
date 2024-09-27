/*
 * Settings.hpp
 *
 *  Created on: 4. dec. 2014
 *      Author: DesktopPC
 */

#ifndef SETTINGS_HPP_
#define SETTINGS_HPP_

#include <QObject>
#include <bb/data/JsonDataAccess>
#include <QFileSystemWatcher>
#include <QStringList>

#define SETTINGS_FILE "data/settings.json"
#define SETTINGS_ERROR "ERROR IN KEY NAME"

class Settings : public QObject
{
    Q_OBJECT
public:
    Settings(QObject * _parent = 0);
    virtual ~Settings();

    Q_INVOKABLE QStringList allKeys();
    Q_INVOKABLE bool contains(const QString & key);
    Q_INVOKABLE void clear();
    Q_INVOKABLE QString fileName();
    Q_INVOKABLE int remove(const QString & key);
    Q_INVOKABLE void setValue(const QString & key, const QVariant & value);
    Q_INVOKABLE void sync();
    Q_INVOKABLE QVariant value(const QString & key, const QVariant & defaultValue = QVariant());

private slots:
    void settingsChanged(const QString & path);

private:
    void save();

    QFileSystemWatcher * watcher;

    bb::data::JsonDataAccess jda;
    QVariantMap settings;
};

#endif /* SETTINGS_HPP_ */
