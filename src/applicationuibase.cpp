/*
 * Copyright (c) 2013-2015 BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "applicationuibase.hpp"

#include <bb/cascades/LocaleHandler>
#include <bb/system/InvokeManager>

using namespace bb::cascades;
using namespace bb::system;

ApplicationUIBase::ApplicationUIBase(InvokeManager *invokeManager) :
        m_pInvokeManager(invokeManager)
{
    m_translator = new QTranslator(this);
    m_pLocaleHandler = new LocaleHandler(this);

    connect(m_pLocaleHandler, SIGNAL(systemLanguageChanged()), this,
            SLOT(onSystemLanguageChanged()));

    // initial load
    onSystemLanguageChanged();
}

ApplicationUIBase::~ApplicationUIBase()
{
    // TODO Auto-generated destructor stub
}

void ApplicationUIBase::onSystemLanguageChanged()
{
    QCoreApplication::instance()->removeTranslator(m_translator);
    // Initiate, load and install the application translation files.
    QString locale_string = QLocale().name();
    QString file_name = QString("AkariShortener_%1").arg(locale_string);
    if (m_translator->load(file_name, "app/native/qm")) {
        QCoreApplication::instance()->installTranslator(m_translator);
    } else {
        qWarning() << tr("cannot load language file '%1").arg(file_name);
    }
}
QString ApplicationUIBase::getv(const QString &objectName, const QString &defaultValue)
{
    QSettings settings;
    if (settings.value(objectName).isNull()) {
        qDebug() << "[SETTINGS]" << objectName << " is " << defaultValue;
        return defaultValue;
    }
    qDebug() << "[SETTINGS]" << objectName << " is " << settings.value(objectName).toString();
    return settings.value(objectName).toString();
}

void ApplicationUIBase::setv(const QString &objectName, const QString &inputValue)
{
    QSettings settings;
    settings.setValue(objectName, QVariant(inputValue));
    qDebug() << "[SETTINGS]" << objectName << " set to " << inputValue;
}

void ApplicationUIBase::setClipboard(QString text)
{
    QByteArray ba = text.toLocal8Bit();

    if (get_clipboard_can_write() == 0) {
        empty_clipboard();
        int ret = set_clipboard_data("text/plain", ba.length(), ba.data());
        if (ret > 0) {
            SystemToast *toast = new SystemToast(this);
            QString message = trUtf8("Copied to clipboard.");
            toast->setBody(message);
            toast->setIcon(QUrl("asset:///icon/ic_done.png"));
            toast->setPosition(SystemUiPosition::MiddleCenter);
            toast->show();
        }
    }
}

QString ApplicationUIBase::getClipboard()
{
    char* pbuffer = 0;
    int ret = get_clipboard_data("text/plain", &pbuffer);
    if (ret > 0) {
        //return the clip board string.
//      std::string data(pbuffer);
        QString da(pbuffer);
        free(pbuffer);
        return da;
    } else {
        //something bad happened,return empty string.
        free(pbuffer);
        return "";
    }
}
