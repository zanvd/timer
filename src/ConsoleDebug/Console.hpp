/*
 * Console.hpp
 *
 *  Created on: 4. dec. 2014
 *      Author: DesktopPC
 */

#ifndef CONSOLE_HPP_
#define CONSOLE_HPP_

#include <QObject>
#include <QtNetwork/QUdpSocket>

#define CLIENT_SENDING_PORT 10465

class Console : public QObject
{
    Q_OBJECT
public:
    Console();
    virtual ~Console();

    void sendMessage(QString _command);

private:
    QUdpSocket * m_socket;
};

#endif /* CONSOLE_HPP_ */
