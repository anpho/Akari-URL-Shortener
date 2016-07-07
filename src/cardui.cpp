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

#include "cardui.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>

#include <bb/system/CardDoneMessage>

using namespace bb::cascades;
using namespace bb::system;

CardUI::CardUI(bb::system::InvokeManager* invokeManager) :
                ApplicationUIBase(invokeManager)
{
    // Create scene document from main.qml asset, the parent is set
    // to ensure the document gets destroyed properly at shut down.
    QmlDocument *qml = QmlDocument::create("qrc:/assets/card.qml").parent(this);

    // Make C++ UI part available to the qml.
    qml->setContextProperty("ApplicationUI", this);

    // Create root object for the UI
    root = qml->createRootObject<AbstractPane>();
    if (root) {
        // Connect to the "invoked" signal to receive invocations
        connect(m_pInvokeManager, SIGNAL(invoked(const bb::system::InvokeRequest&)),
                this, SLOT(onInvoked(const bb::system::InvokeRequest&)));

        // Connect to the "cardPooled" signal to received notifications when the card is placed in the pool
        connect(m_pInvokeManager, SIGNAL(cardPooled(const bb::system::CardDoneMessage&)),
                this, SLOT(cardPooled(const bb::system::CardDoneMessage&)));

        // Set created root object as the application scene
        Application::instance()->setScene(root);
    }
}

void CardUI::cardPooled(const bb::system::CardDoneMessage& doneMessage)
{
    // Card is no longer being shown and has been pooled
    // The card process is still running, but has been pooled so that future invocations are optimized.
    // Therefore, when the card receives this signal, it must reset its state so that it is ready
    // to be invoked cleanly again. For example, for a composer, any input should be discarded.
    qDebug() << "cardPooled: " << doneMessage.reason();

    // TODO: Clean-up and release any resource the card might have used.

}

void CardUI::onInvoked(const bb::system::InvokeRequest& request)
{
    qDebug() << "onInvoked request:";

    bb::system::InvokeSource source = request.source();
    QString memo = QString::fromUtf8(request.data());

    qDebug() << "Source: (" << source.groupId() << "," << source.installId() << ")";
    qDebug() << "Target:" << request.target();
    qDebug() << "Action:" << request.action();
    qDebug() << "Mime:" << request.mimeType();
    qDebug() << "Url:" << request.uri();
    qDebug() << "Data:" << memo;
    if (request.uri().toString().length()>0){
        emit memoChanged(request.uri().toString());
    }else{
        emit memoChanged(memo);
    }
}

