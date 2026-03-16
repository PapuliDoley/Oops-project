#include "databasemanager.h"
#include <QSqlError>
#include <QDebug>

DatabaseManager::DatabaseManager(QObject *parent) : QObject(parent) {}

void DatabaseManager::initDatabase() {
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("clinic.db");

    if (!db.open()) {
        qDebug() << "Database Error: " << db.lastError().text();
        return;
    }

    QSqlQuery q;
    // Create Users table for Login/Register
    q.exec("CREATE TABLE IF NOT EXISTS users ("
           "id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT UNIQUE, "
           "password TEXT, role TEXT)");

    // Create Appointments table for Doctor-Patient interaction
    q.exec("CREATE TABLE IF NOT EXISTS appointments ("
           "id INTEGER PRIMARY KEY AUTOINCREMENT, doctor_id INTEGER, "
           "patient_name TEXT, history TEXT, prescription TEXT, status TEXT DEFAULT 'Pending')");
}

bool DatabaseManager::loginUser(QString email, QString password, QString role) {
    QSqlQuery q;
    q.prepare("SELECT * FROM users WHERE email = ? AND password = ? AND role = ?");
    q.addBindValue(email);
    q.addBindValue(password);
    q.addBindValue(role);
    return q.exec() && q.next();
}

bool DatabaseManager::registerUser(QString name, QString email, QString password, QString role) {
    QSqlQuery q;
    q.prepare("INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)");
    q.addBindValue(name);
    q.addBindValue(email);
    q.addBindValue(password);
    q.addBindValue(role);
    return q.exec();
}

void DatabaseManager::bookAppointment(int doctorId, QString patientName, QString history) {
    QSqlQuery q;
    q.prepare("INSERT INTO appointments (doctor_id, patient_name, history) VALUES (?, ?, ?)");
    q.addBindValue(doctorId);
    q.addBindValue(patientName);
    q.addBindValue(history);
    q.exec();
}

void DatabaseManager::sendPrescription(int apptId, QString meds) {
    QSqlQuery q;
    q.prepare("UPDATE appointments SET prescription = ?, status = 'Completed' WHERE id = ?");
    q.addBindValue(meds);
    q.addBindValue(apptId);
    q.exec();
}
