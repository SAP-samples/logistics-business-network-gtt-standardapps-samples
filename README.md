# Fulfillment Tracking Apps for SAP Logistics Business Network, Global Track and Trace Option

## What's New in the 2202 Release

1.	Track SO Fulfillment and Track PO Fulfillment standard apps are now available for use with Version 2. You can use the two apps to track the fulfilment status of sales orders and purchase orders. The following delivered contents are updated: 
*	[SAP ERP Sample Code Configuration Guide for Fulfillment Tracking Apps.pdf](https://github.com/SAP-samples/logistics-business-network-gtt-standardapps-samples/blob/master/lbn-gtt-standard-app/Documents/SAP%20ERP%20Sample%20Code%20Configuration%20Guide%20for%20Fulfillment%20Tracking%20Apps.pdf)
*	Configuration file for SAP ERP extractors 
*	Sample code for SAP ERP extractors to send the tracked processes and events to the global track and trace option (ABAP). 
2.	A new tracked object type "IMO" is added for ocean freight booking.
3.	Issues on reporting "Delay" and "Proof of Pickup" events are fixed.


## What's New in the 2112 Release

The location type in the following tracked processes is changed from "Supplier" / "Customer" to "BusinessPartner":</br>
* InboundDelivery </br>
*	InboundDeliveryItem</br>
*	Shipment.


## What's New in the 2111 Release

1. Retrieve the location types of the freight orders, freight bookings, freight units and actual events from location master data in SAP S/4HANA instead of hard coding them as “LogisticLocation”. 
2. Remove the inboundDeliveryTPs table from the LE-TRA inbound shipment. 
3. Send the inbound delivery number to the shipper reference document table of the LE-TRA inbound shipment. 
4. For the events "Putaway" and "Goods Receipt" of an inbound delivery,  the extraction mode of their quantity is changed from "Delta" to "Full".


## What's New in the 2109 Release
 
1. "Reference Document No." field is added into the "InboundDeliveryItem" tracked process.
2. In the inbound delivery item extractor, inbound delivery items no longer observe inbound deliveries.
3. The actual event "Goods Receipt" in SAP ERP is now tracked by the global track and trace option, and extracted into the "InboundDeliveryItem" tracked process.
4. The planned events "Departure" , "Arrival", and "Proof of Delivery" are removed from the "InboundDeliveryItem" tracked process.


## What's New in the 2108 Release
1.	The GTT standard model no longer supports mutual observation between freight orders and freight units. Now only freight units observe freight orders. To achieve this, the following changes are made:</br>
*	Freight orders no longer observe freight units in the freight order extractor </br>
*	Remove the freight unit’s first stop and last stop in the freight order extractor </br>
*	Fill in "additionalMatchKey = TMFU" if the event is propagated from freight units to freight orders and sent to the GTT system via the freight order's actual event extractor.</br>
2.	Remove the leading zero in the document number and tracking ID of inbound delivery orders, inbound delivery items , freight orders, freight units, and shipments.</br>
3.  Regarding to removing leading zero changes, some adjustments are required for the extractor configurations.</br>
  For more details, please refer to file [SAP ERP Sample Code Configuration Guide for Fulfillment Tracking Apps.pdf](https://github.com/SAP-samples/logistics-business-network-gtt-standardapps-samples/blob/master/lbn-gtt-standard-app/Documents/SAP%20ERP%20Sample%20Code%20Configuration%20Guide%20for%20Fulfillment%20Tracking%20Apps.pdf) (In page 3 from step 2 to step 7).</br>


## What's New in the 2107 Release
Based on the event type and stop sequence, fill in the payload sequence field for the planned events of the inbound delivery, inbound delivery item, LE-TRA shipment, freight order, freight booking and freight unit.</br>

## What's New in the 2106 Release
1. Separately send freight order, freight booking and freight unit’s reference documents to the carrier reference document table and the shipper reference document table in the Track Shipments app according to the document type. Currently we only support the following document types:</br>
* Shipper reference document type: 001(Purchase Order), 58(Inbound Delivery), 114(Sales Order), 73(Outbound Delivery)</br>
* Carrier reference document type: T50(Bill of Lading), T52 (Master Bill of Lading), T55(Master Air Waybill), BN(Consignment Identifier)</br>
2.	The GTT standard model supports mutual observation between shipments and freight units. From the extractor side, the freight unit’s actual events will no longer be sent to the GTT system directly. The current propagation flow is: TM freight unit -> TM freight order -> GTT shipment -> GTT freight unit.</br>
3.	To enable integration with Air Sense, the air freight booking’s flight number is now sent as a tracked object.</br>
4. Remove Created by Business User from the Inbound Delivery Tracked Process.</br>
5. Remove valid-from and valid-to value extracting from SAP ERP and let the GTT system to set the default values.</br>

## Description
You can find the sample code for SAP ERP extractors that are necessary to integrate SAP ERP with [SAP Logistics Business Network, global track and trace option](https://help.sap.com/viewer/product/SAP_LBN_GTT_OPTION/LBN/en-US?task=discover_task) in this project. You can either implement the sample code or customize it to fit your needs. The delivered contents include: 

* Sample code for SAP ERP extractors to send the tracked processes and events to the global track and trace option (ABAP)
* Configuration file for SAP ERP extractors

 
## Requirements

* To integrate with the global track and trace option, your SAP ERP system shall be SAP EHP1 FOR SAP NETWEAVER 7.3 or higher.
* To implement the extractor sample code in this repository, your SAP ERP system shall be S4 HANA 1909 SP03 on premise. Note that the sample code is not validated in a lower release, and not applicable for ECC series of products.


## Download and Installation
Click the link below to find the detailed installation guide. You can also find the guide in the “Document” folder.
* [SAP ERP Sample Code Configuration Guide for Fulfillment Tracking Apps.pdf](https://github.com/SAP-samples/logistics-business-network-gtt-standardapps-samples/blob/master/lbn-gtt-standard-app/Documents/SAP%20ERP%20Sample%20Code%20Configuration%20Guide%20for%20Fulfillment%20Tracking%20Apps.pdf) </br>


## Known Issues
If multiple IDOC payloads are generated at the same time or in a very short period of time in SAP ERP, these payloads might enter the global track and trace system in disorder. This might cause update errors in some situations.

## How to Obtain Support
The project is provided "as-is", with no expected support. </br>
If your issue is concerned with global track and trace option, log your incident in SAP support system with component “SCM-LBN-GTT-TSH” for Track Shipments app and “SCM-LBN-GTT-MIA” for Monitor Inbound ASNs app. 

For additional support, [ask a question in SAP Community](https://answers.sap.com/questions/ask.html?additionalTagId=73555000100800000602).

## License
Copyright (c) 2020 SAP SE or an SAP affiliate company. All rights reserved. This project is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](https://github.com/SAP-samples/logistics-business-network-gtt-samples/blob/master/LICENSES/Apache-2.0.txt) file.

## Reuse Status
[![REUSE status](https://api.reuse.software/badge/github.com/SAP-samples/logistics-business-network-gtt-standardapps-samples)](https://api.reuse.software/info/github.com/SAP-samples/logistics-business-network-gtt-standardapps-samples)
