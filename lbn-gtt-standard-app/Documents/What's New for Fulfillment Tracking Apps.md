# What's New for Fulfillment Tracking Apps
## Oct 15th, 2022
1. Add the "Reported By" field for all the tracked processes and actual events. 
2. Remove the Resource TPs table in the shipment and freight order exactor. 
3. When a freight unit observes a freight order, if there is multi-layer data from the freight unit to the freight order (example: freight unit -> container unit -> freight order), the relationship between the freight unit and the freight order can still be retrieved. 
4. The receiving location of the inbound delivery is corrected from "Plant" to "Shipping Point"; Now the "Proof of Delivery" planned event of a shipment is created when the receiving location is "Shipping Point".
5. When no location is provided, the location type should be set to null.
6. The “FreightUnit” tracked process now gets values of transportation mode / carrier / shipping type from the freight unit document itself.
7. Exceptions that occur when reporting events on container units are no longer handled.
## Aug 20th, 2022
1. In the TM scenario, if you maintain container numbers on container units in SAP TM, the container units can now be sent as tracking units for tracking. For implementation details, see [Implementation Guide for Tracking via Tracking Unit and Reference Document in the TM Scenario](https://github.com/SAP-samples/logistics-business-network-gtt-standardapps-samples/blob/main/lbn-gtt-standard-app/Documents/Implementation%20Guide%20for%20Tracking%20via%20Tracking%20Unit%20and%20Reference%20Document%20in%20the%20TM%20Scenario.pdf).
2. When no location is provided, the location type should be set to null.
3. The "FreightUnit" tracked process now gets values of transportation mode / carrier / shipping type from the freight unit document itself.

## Jul 16th, 2022
1. For the features that are only available in the test tenants, there is now a separate test branch available where you can download the relevant codes and documents. To access it, choose "test" from the dropdown menu on the top left. 
2. The timestamp fields in the extractor are enhanced as follows: 
* For timestamp fields in the Control Parameters functions: use UTC time.
* For timestamp fields in the rest of the functions: use local time and its corresponding time zone or the time zone in the ERP system. 
3. If a tracked object is deleted in the scenario "Maintain Tracked Objects on Freight Order/Freight Booking", this tracked object is now also removed from the Tracked Objects table.


## Jun 18th, 2022
1. Timestamp localization codes are improved.
2. The valid from/to segment (1970/9999) is removed from all the Tracking ID functions.
3. All location types in the freight order, freight booking, and freight unit are changed to "LogisticLocation". You can either download the latest version of extractor or change location types manually in Method GET_LOCATION_TYPE of Class ZCL_GTT_STS_TOOLS. 
4. A new tracked process “TrackingUnit” is introduced in the standard model “gttft1” for you to track the shipments and freight units that have multiple tracked objects in the TM scenario. For example, you can maintain multiple external package IDs on freight units for parcel tracking. The following content is delivered to help you with the implementation: [Implementation Guide for Tracking via Tracking Unit and Reference Document in the TM Scenario](https://github.com/SAP-samples/logistics-business-network-gtt-standardapps-samples/blob/master/lbn-gtt-standard-app/Documents/Implementation%20Guide%20for%20Tracking%20via%20Tracking%20Unit%20and%20Reference%20Document%20in%20the%20TM%20Scenario.pdf).


## May 21st, 2022
1. Fix the issue of not sending "Shipping Type" and "Traffic Direction" to the GTT system after saving the freight order.
2. Fix the timestamp localization issue after synchronizing ETA of the inbound delivery to the ERP system.

## Apr 23rd, 2022
1. Fix the issue of extractor short dump caused by the missing partner function "Ship-to party" in the outbound delivery.
2. Remove "binary search" in Read Table statement in the Track SO Fulfillment extractor code.

## Mar 19th, 2022
1. IDOC processing out-of-sequence is fixed when updating the inbound delivery / inbound delivery item / outbound delivery / outbound delivery item after a freight unit is generated.
2. Unit of Measure of sales order items / outbound delivery / outbound delivery items is corrected.


## Feb 19th, 2022
1.	Track SO Fulfillment and Track PO Fulfillment standard apps are now available for use with Version 2. You can use the two apps to track the fulfilment status of sales orders and purchase orders. The following delivered contents are updated: 
*	[SAP ERP Sample Code Configuration Guide for Fulfillment Tracking Apps.pdf](https://github.com/SAP-samples/logistics-business-network-gtt-standardapps-samples/blob/master/lbn-gtt-standard-app/Documents/SAP%20ERP%20Sample%20Code%20Configuration%20Guide%20for%20Fulfillment%20Tracking%20Apps.pdf)
*	Configuration file for SAP ERP extractors 
*	Sample code for SAP ERP extractors to send the tracked processes and events to the global track and trace option (ABAP). 
2.	A new tracked object type "IMO" is added for ocean freight booking.
3.	Issues on reporting "Delay" and "Proof of Pickup" events are fixed.


## Dec 11th, 2021

The location type in the following tracked processes is changed from "Supplier" / "Customer" to "BusinessPartner":</br>
* InboundDelivery </br>
*	InboundDeliveryItem</br>
*	Shipment.


## Nov 13th, 2021

1. Retrieve the location types of the freight orders, freight bookings, freight units and actual events from location master data in SAP S/4HANA instead of hard coding them as “LogisticLocation”. 
2. Remove the inboundDeliveryTPs table from the LE-TRA inbound shipment. 
3. Send the inbound delivery number to the shipper reference document table of the LE-TRA inbound shipment. 
4. For the events "Putaway" and "Goods Receipt" of an inbound delivery,  the extraction mode of their quantity is changed from "Delta" to "Full".


## Sep 18th, 2021
 
1. "Reference Document No." field is added into the "InboundDeliveryItem" tracked process.
2. In the inbound delivery item extractor, inbound delivery items no longer observe inbound deliveries.
3. The actual event "Goods Receipt" in SAP ERP is now tracked by the global track and trace option, and extracted into the "InboundDeliveryItem" tracked process.
4. The planned events "Departure" , "Arrival", and "Proof of Delivery" are removed from the "InboundDeliveryItem" tracked process.


## Aug 21st, 2021
1.	The GTT standard model no longer supports mutual observation between freight orders and freight units. Now only freight units observe freight orders. To achieve this, the following changes are made:</br>
*	Freight orders no longer observe freight units in the freight order extractor </br>
*	Remove the freight unit’s first stop and last stop in the freight order extractor </br>
*	Fill in "additionalMatchKey = TMFU" if the event is propagated from freight units to freight orders and sent to the GTT system via the freight order's actual event extractor.</br>
2.	Remove the leading zero in the document number and tracking ID of inbound delivery orders, inbound delivery items , freight orders, freight units, and shipments.</br>
3. Regarding removing leading zero changes, some adjustments are required for the extractor configurations.</br>
  For more details, please refer to file [SAP ERP Sample Code Configuration Guide for Fulfillment Tracking Apps.pdf](https://github.com/SAP-samples/logistics-business-network-gtt-standardapps-samples/blob/master/lbn-gtt-standard-app/Documents/SAP%20ERP%20Sample%20Code%20Configuration%20Guide%20for%20Fulfillment%20Tracking%20Apps.pdf) (In page 3 from step 2 to step 7).</br>


## Jul 17th, 2021
Based on the event type and stop sequence, fill in the payload sequence field for the planned events of the inbound delivery, inbound delivery item, LE-TRA shipment, freight order, freight booking and freight unit.</br>

## Jun 19th, 2021
1. Separately send freight order, freight booking and freight unit’s reference documents to the carrier reference document table and the shipper reference document table in the Track Shipments app according to the document type. Currently we only support the following document types:</br>
* Shipper reference document type: 001(Purchase Order), 58(Inbound Delivery), 114(Sales Order), 73(Outbound Delivery)</br>
* Carrier reference document type: T50(Bill of Lading), T52 (Master Bill of Lading), T55(Master Air Waybill), BN(Consignment Identifier)</br>
2.	The GTT standard model supports mutual observation between shipments and freight units. From the extractor side, the freight unit’s actual events will no longer be sent to the GTT system directly. The current propagation flow is: TM freight unit -> TM freight order -> GTT shipment -> GTT freight unit.</br>
3.	To enable integration with Air Sense, the air freight booking’s flight number is now sent as a tracked object.</br>
4. Remove Created by Business User from the Inbound Delivery Tracked Process.</br>
5. Remove valid-from and valid-to value extracting from SAP ERP and let the GTT system to set the default values.</br>
