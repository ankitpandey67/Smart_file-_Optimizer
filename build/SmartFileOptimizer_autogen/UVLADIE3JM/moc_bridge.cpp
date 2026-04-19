/****************************************************************************
** Meta object code from reading C++ file 'bridge.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.11.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../src/bridge.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'bridge.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 69
#error "This file was generated using the moc from 6.11.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN6BridgeE_t {};
} // unnamed namespace

template <> constexpr inline auto Bridge::qt_create_metaobjectdata<qt_meta_tag_ZN6BridgeE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "Bridge",
        "selectedFolderChanged",
        "",
        "statsChanged",
        "dupStatsChanged",
        "folderPickerResult",
        "path",
        "notification",
        "type",
        "message",
        "setSelectedFolder",
        "startScan",
        "cancelScan",
        "organizeFiles",
        "dryRun",
        "undoOrganize",
        "detectDuplicates",
        "exportLog",
        "openFolderPicker",
        "categoryColor",
        "cat",
        "log",
        "Logger*",
        "settings",
        "SettingsManager*",
        "scanner",
        "FileScanner*",
        "organizer",
        "FileOrganizer*",
        "dupes",
        "DuplicateDetector*",
        "selectedFolder",
        "totalFiles",
        "totalSizeMB",
        "totalSizeStr",
        "categoryStats",
        "QVariantList",
        "largeFiles",
        "dupGroupCount",
        "dupWastedStr",
        "dupGroups"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'selectedFolderChanged'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'statsChanged'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'dupStatsChanged'
        QtMocHelpers::SignalData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'folderPickerResult'
        QtMocHelpers::SignalData<void(const QString &)>(5, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 },
        }}),
        // Signal 'notification'
        QtMocHelpers::SignalData<void(const QString &, const QString &)>(7, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 8 }, { QMetaType::QString, 9 },
        }}),
        // Slot 'setSelectedFolder'
        QtMocHelpers::SlotData<void(const QString &)>(10, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 },
        }}),
        // Slot 'startScan'
        QtMocHelpers::SlotData<void()>(11, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'cancelScan'
        QtMocHelpers::SlotData<void()>(12, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'organizeFiles'
        QtMocHelpers::SlotData<void(bool)>(13, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 14 },
        }}),
        // Slot 'undoOrganize'
        QtMocHelpers::SlotData<void()>(15, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'detectDuplicates'
        QtMocHelpers::SlotData<void()>(16, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'exportLog'
        QtMocHelpers::SlotData<void(const QString &)>(17, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 },
        }}),
        // Slot 'openFolderPicker'
        QtMocHelpers::SlotData<void()>(18, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'categoryColor'
        QtMocHelpers::SlotData<QString(const QString &) const>(19, 2, QMC::AccessPublic, QMetaType::QString, {{
            { QMetaType::QString, 20 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'log'
        QtMocHelpers::PropertyData<Logger*>(21, 0x80000000 | 22, QMC::DefaultPropertyFlags | QMC::EnumOrFlag | QMC::Constant),
        // property 'settings'
        QtMocHelpers::PropertyData<SettingsManager*>(23, 0x80000000 | 24, QMC::DefaultPropertyFlags | QMC::EnumOrFlag | QMC::Constant),
        // property 'scanner'
        QtMocHelpers::PropertyData<FileScanner*>(25, 0x80000000 | 26, QMC::DefaultPropertyFlags | QMC::EnumOrFlag | QMC::Constant),
        // property 'organizer'
        QtMocHelpers::PropertyData<FileOrganizer*>(27, 0x80000000 | 28, QMC::DefaultPropertyFlags | QMC::EnumOrFlag | QMC::Constant),
        // property 'dupes'
        QtMocHelpers::PropertyData<DuplicateDetector*>(29, 0x80000000 | 30, QMC::DefaultPropertyFlags | QMC::EnumOrFlag | QMC::Constant),
        // property 'selectedFolder'
        QtMocHelpers::PropertyData<QString>(31, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 0),
        // property 'totalFiles'
        QtMocHelpers::PropertyData<int>(32, QMetaType::Int, QMC::DefaultPropertyFlags, 1),
        // property 'totalSizeMB'
        QtMocHelpers::PropertyData<double>(33, QMetaType::Double, QMC::DefaultPropertyFlags, 1),
        // property 'totalSizeStr'
        QtMocHelpers::PropertyData<QString>(34, QMetaType::QString, QMC::DefaultPropertyFlags, 1),
        // property 'categoryStats'
        QtMocHelpers::PropertyData<QVariantList>(35, 0x80000000 | 36, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 1),
        // property 'largeFiles'
        QtMocHelpers::PropertyData<QVariantList>(37, 0x80000000 | 36, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 1),
        // property 'dupGroupCount'
        QtMocHelpers::PropertyData<int>(38, QMetaType::Int, QMC::DefaultPropertyFlags, 2),
        // property 'dupWastedStr'
        QtMocHelpers::PropertyData<QString>(39, QMetaType::QString, QMC::DefaultPropertyFlags, 2),
        // property 'dupGroups'
        QtMocHelpers::PropertyData<QVariantList>(40, 0x80000000 | 36, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 2),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<Bridge, qt_meta_tag_ZN6BridgeE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject Bridge::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN6BridgeE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN6BridgeE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN6BridgeE_t>.metaTypes,
    nullptr
} };

void Bridge::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<Bridge *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->selectedFolderChanged(); break;
        case 1: _t->statsChanged(); break;
        case 2: _t->dupStatsChanged(); break;
        case 3: _t->folderPickerResult((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 4: _t->notification((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[2]))); break;
        case 5: _t->setSelectedFolder((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 6: _t->startScan(); break;
        case 7: _t->cancelScan(); break;
        case 8: _t->organizeFiles((*reinterpret_cast<std::add_pointer_t<bool>>(_a[1]))); break;
        case 9: _t->undoOrganize(); break;
        case 10: _t->detectDuplicates(); break;
        case 11: _t->exportLog((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 12: _t->openFolderPicker(); break;
        case 13: { QString _r = _t->categoryColor((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast<QString*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (Bridge::*)()>(_a, &Bridge::selectedFolderChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (Bridge::*)()>(_a, &Bridge::statsChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (Bridge::*)()>(_a, &Bridge::dupStatsChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (Bridge::*)(const QString & )>(_a, &Bridge::folderPickerResult, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (Bridge::*)(const QString & , const QString & )>(_a, &Bridge::notification, 4))
            return;
    }
    if (_c == QMetaObject::RegisterPropertyMetaType) {
        switch (_id) {
        default: *reinterpret_cast<int*>(_a[0]) = -1; break;
        case 4:
            *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< DuplicateDetector* >(); break;
        case 3:
            *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< FileOrganizer* >(); break;
        case 2:
            *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< FileScanner* >(); break;
        case 0:
            *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< Logger* >(); break;
        case 1:
            *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< SettingsManager* >(); break;
        }
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<Logger**>(_v) = _t->log(); break;
        case 1: *reinterpret_cast<SettingsManager**>(_v) = _t->settings(); break;
        case 2: *reinterpret_cast<FileScanner**>(_v) = _t->scanner(); break;
        case 3: *reinterpret_cast<FileOrganizer**>(_v) = _t->organizer(); break;
        case 4: *reinterpret_cast<DuplicateDetector**>(_v) = _t->dupes(); break;
        case 5: *reinterpret_cast<QString*>(_v) = _t->selectedFolder(); break;
        case 6: *reinterpret_cast<int*>(_v) = _t->totalFiles(); break;
        case 7: *reinterpret_cast<double*>(_v) = _t->totalSizeMB(); break;
        case 8: *reinterpret_cast<QString*>(_v) = _t->totalSizeStr(); break;
        case 9: *reinterpret_cast<QVariantList*>(_v) = _t->categoryStats(); break;
        case 10: *reinterpret_cast<QVariantList*>(_v) = _t->largeFiles(); break;
        case 11: *reinterpret_cast<int*>(_v) = _t->dupGroupCount(); break;
        case 12: *reinterpret_cast<QString*>(_v) = _t->dupWastedStr(); break;
        case 13: *reinterpret_cast<QVariantList*>(_v) = _t->dupGroups(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 5: _t->setSelectedFolder(*reinterpret_cast<QString*>(_v)); break;
        default: break;
        }
    }
}

const QMetaObject *Bridge::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Bridge::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN6BridgeE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int Bridge::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 14)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 14;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 14)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 14;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 14;
    }
    return _id;
}

// SIGNAL 0
void Bridge::selectedFolderChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void Bridge::statsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void Bridge::dupStatsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void Bridge::folderPickerResult(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 3, nullptr, _t1);
}

// SIGNAL 4
void Bridge::notification(const QString & _t1, const QString & _t2)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 4, nullptr, _t1, _t2);
}
QT_WARNING_POP
