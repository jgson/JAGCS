#include "vehicle_list_presenter.h"

// Qt
#include <QSortFilterProxyModel>
#include <QVariant>
#include <QDebug>

// Internal
#include "settings_provider.h"

#include "vehicle.h"

#include "service_registry.h"
#include "vehicle_service.h"

#include "vehicle_list_model.h"

using namespace presentation;

class VehicleListPresenter::Impl
{
public:
    domain::VehicleService* const service = serviceRegistry->vehicleService();

    VehicleListModel vehiclesModel;
    QSortFilterProxyModel sortingModel;
};

VehicleListPresenter::VehicleListPresenter(QObject* parent):
    BasePresenter(parent),
    d(new Impl())
{
    d->sortingModel.setSourceModel(&d->vehiclesModel);
    d->sortingModel.setFilterRole(VehicleListModel::VehicleNameRole);
    d->sortingModel.setSortRole(VehicleListModel::VehicleNameRole);
    d->sortingModel.setDynamicSortFilter(true);
    d->sortingModel.sort(0, Qt::AscendingOrder);

    d->vehiclesModel.setVehicles(d->service->vehicles());

    connect(d->service, &domain::VehicleService::vehicleAdded,
            &d->vehiclesModel, &VehicleListModel::addVehicle);
    connect(d->service, &domain::VehicleService::vehicleRemoved,
            &d->vehiclesModel, &VehicleListModel::removeVehicle);
    connect(d->service, &domain::VehicleService::vehicleChanged,
            &d->vehiclesModel, &VehicleListModel::updateVehicle);
}

VehicleListPresenter::~VehicleListPresenter()
{}

void VehicleListPresenter::addVehicle()
{
    d->service->addNewVehicle();
}

void VehicleListPresenter::setAutoAdd(bool add)
{
    settings::Provider::setValue(settings::communication::autoAdd, QVariant(add));
}

void VehicleListPresenter::filter(const QString& filterString)
{
    d->sortingModel.setFilterFixedString(filterString);
}

void VehicleListPresenter::connectView(QObject* view)
{
    view->setProperty(PROPERTY(vehicles), QVariant::fromValue(&d->sortingModel));
    view->setProperty(PROPERTY(autoAdd),
                      settings::Provider::value(settings::communication::autoAdd));
}
