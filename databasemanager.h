#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>

class DatabaseManager : public QObject {
    Q_OBJECT
public:
    explicit DatabaseManager(QObject *parent = nullptr);

    // This makes the functions visible to your Main.qml
    Q_INVOKABLE void initDatabase();
    Q_INVOKABLE bool loginUser(QString email, QString password, QString role);
    Q_INVOKABLE bool registerUser(QString name, QString email, QString password, QString role);
    Q_INVOKABLE void bookAppointment(int doctorId, QString patientName, QString history);
    Q_INVOKABLE void sendPrescription(int apptId, QString meds);

private:
    QSqlDatabase db; // This fixes the 'db' undeclared identifier error
};

#endif
