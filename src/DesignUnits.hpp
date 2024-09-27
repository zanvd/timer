/*
 * DesignUnits.hpp
 *
 *  Created on: 2014-10-26
 *      Author: Roger
 */

#ifndef DESIGNUNITS_HPP_
#define DESIGNUNITS_HPP_

#include <bb/device/HardwareInfo>

class DesignUnits : public QObject
{
    Q_OBJECT

public:
    DesignUnits();
    virtual ~DesignUnits();

    Q_INVOKABLE int du(const double & units);

private:
    bb::device::HardwareInfo * thisDevice;
};

#endif /* DESIGNUNITS_HPP_ */
