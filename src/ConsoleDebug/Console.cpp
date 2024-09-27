/*
 * Console.cpp
 *
 *  Created on: 4. dec. 2014
 *      Author: DesktopPC
 */

#include "src/ConsoleDebug/console.hpp"

#include <QStringList>
#include <bb/ApplicationInfo>

Console::Console() :
    QObject(),
    m_socket(new QUdpSocket(this))
{
}

Console::~Console()
{
    m_socket -> deleteLater();
}

void Console::sendMessage(QString _data)
{
    bb::ApplicationInfo appInfo;
    QString message = appInfo.title() + "$$" + _data;

    m_socket -> writeDatagram(message.toStdString().c_str(), QHostAddress("127.0.0.1"), CLIENT_SENDING_PORT);
}
