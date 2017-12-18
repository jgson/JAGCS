#ifndef SATELLITE_DISPLAY_PRESENTER_H
#define SATELLITE_DISPLAY_PRESENTER_H

// Internal
#include "abstract_display_presenter.h"

namespace presentation
{
    class SatelliteDisplayPresenter: public AbstractDisplayPresenter
    {
        Q_OBJECT

    public:
        explicit SatelliteDisplayPresenter(QObject* parent = nullptr);

    protected:
        void connectNode(domain::Telemetry* node) override;

    private slots:
        void updateSatellite(const domain::Telemetry::TelemetryMap& parameters);
    };
}

#endif // SATELLITE_DISPLAY_PRESENTER_H