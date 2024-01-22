# What's New for Fulfillment Tracking Apps
## January 20th, 2024
1. You can send the carrier’s note to SAP Business Network Global Track and Trace as shipment’s tracked object to initialize tracking.
2. Add the planned "Arrival" event on the source location of the LTL shipment.
3. The actual events that you report in SAP S/4HANA 2023 can be sent to SAP Business Network Global Track and Trace.
4. Fix the planned “Proof of Delivery” event issue for inbound deliveries.
5. Fix one-time location relevant issues. 
6. The document "SAP ERP Sample Code Configuration Guide for Fulfillment Tracking Apps" is renamed "[Sample Code Configuration Guide for Integration with SAP Business Network Global Track and Trace](https://github.wdf.sap.corp/TrackAndTrace/GTT-V2-Standard-Apps/blob/main/lbn-gtt-standard-app/Documents/Sample%20Code%20Configuration%20Guide%20for%20Integration%20with%20SAP%20Business%20Network%20Global%20Track%20and%20Trace.pdf)".

## November 11th, 2023
1. When reporting actual events in SAP TM with the event reason code provided, the event reason code can now be sent to SAP Business Network Global Track and Trace.
2. Fix the "Proof of Delivery" event match key for the freight unit.
3. Enhance the logic of the field "isFreightUnitRelevant" on the delivery header.
4. When the freight unit is updated and sent to SAP Business Network Global Track and Trace, the preceding inbound/outbound delivery header will not be updated. 

## September 16th, 2023 
1. Support batch split for the inbound and outbound delivery.
2. Correct shipper reference documents information after removing a delivery from a shipment.
3. Fix the update issue of the inbound delivery item when canceling one of its freight units.  
4. If the Goods Movement status is empty, the item Goods Receipt events (with event match key) are not planned for the inbound delivery header.
5. Enhance the trigger condition of freight unit's cross updating delivery and delivery items.
6. Fix the duplicate alternative keys issue when several handling units are assigned to one freight unit of an inbound delivery.

## June 17th, 2023
1. Correct the unit of measure in the freight booking.
2. Stop sending out the freight unit IDOC if this freight unit is not GTT relevant.

## April 22nd, 2023
1. Support sending one-time locations from the ERP system to the GTT system.
2. Send package ID of the LE-TRA Shipment to the GTT system as the tracked object.
3. Fix the location ID (LOCID1) in planned "Goods Receipt" event of the outbound delivery for the stock transport order scenario.
4. Fix the observation issue that occurs between inbound delivery header and its items when running the batch job.
5. In the scenario "Maintain Tracked Objects on Container Unit", enhance the logic to retrieve the freight unit data from the freight order.

## March 18th, 2023
1. SAP Business Network Global Track and Trace now supports the tracking of stock transport orders. 
2. Add the configuration table for the inbound delivery type and purchase order type.    
3. Add sales order and purchase order numbers in shipper reference documents of the LE-TRA shipment. 
4. To keep the unit of measure consistent between the delivery and its freight unit, add the freight unit's base quantity and base unit of measure to inbound and outbound delivery items.
5. Correct the unit of measure in the inbound delivery header / inbound delivery item / purchase order item / freight unit / freight order.
6. Remove the leading zero in the ship-to party, sold-to party and material ID of the inbound delivery item / sales order / sales order item / outbound delivery header / outbound delivery item. 

## December 10th, 2022
1. Add denominator and numerator fields for the sales order item / outbound delivery item.
2. Add the configuration table for the outbound delivery type / sales order type.
3. Support carrier reference document type T67 (Reference Number of Carrier) for the TM scenario.
4. In the scenario "Maintain Tracked Objects on Freight Order/Freight Booking", if there is multi-layer data from the freight unit to the freight order (example: freight unit -> container unit -> freight order), the relationship between the freight unit and the freight order can still be retrieved.

## November 12th, 2022
1. To support tracking without carrier onboarding, the Standard Carrier Alpha Code (SCAC) of a carrier can be retrieved.
2. For the outbound delivery and the outbound delivery item, remove the configuration check of "Define Transportation-Relevance of Delivery Documents" in control parameters and planned events.
3. In the scenario "Maintain Tracked Objects on Freight Order/Freight Booking", the issue of missing planned “Departure” and “Arrival” events in the freight unit is fixed.

## October 15th, 2022
1. Add the "Reported By" field for all the tracked processes and actual events. 
2. Remove the Resource TPs table in the shipment and freight order extractor. 
3. When a freight unit observes a freight order, if there is multi-layer data from the freight unit to the freight order (example: freight unit -> container unit -> freight order), the relationship between the freight unit and the freight order can still be retrieved. 
4. The receiving location of the inbound delivery is corrected from "Plant" to "Shipping Point"; Now the "Proof of Delivery" planned event of a shipment is created when the receiving location is "Shipping Point".
5. When no location is provided, the location type should be set to null.
6. The “FreightUnit” tracked process now gets values of transportation mode / carrier / shipping type from the freight unit document itself.
7. Exceptions that occur when reporting events on container units are no longer handled.

## August 20th, 2022
1. In the TM scenario, if you maintain container numbers on container units in SAP TM, the container units can now be sent as tracking units for tracking. For implementation details, see [Implementation Guide for Tracking via Tracking Unit and Reference Document in the TM Scenario](https://github.com/SAP-samples/logistics-business-network-gtt-standardapps-samples/blob/main/lbn-gtt-standard-app/Documents/Implementation%20Guide%20for%20Tracking%20via%20Tracking%20Unit%20and%20Reference%20Document%20in%20the%20TM%20Scenario.pdf).
2. When no location is provided, the location type should be set to null.
3. The "FreightUnit" tracked process now gets values of transportation mode / carrier / shipping type from the freight unit document itself.

## July 16th, 2022
1. For the features that are only available in the test tenants, there is now a separate test branch available where you can download the relevant codes and documents. To access it, choose "test" from the dropdown menu on the top left. 
2. The timestamp fields in the extractor are enhanced as follows: 
* For timestamp fields in the Control Parameters functions: use UTC time.
* For timestamp fields in the rest of the functions: use local time and its corresponding time zone or the time zone in the ERP system. 
3. If a tracked object is deleted in the scenario "Maintain Tracked Objects on Freight Order/Freight Booking", this tracked object is now also removed from the Tracked Objects table.


## June 18th, 2022
1. Timestamp localization codes are improved.
2. The valid from/to segment (1970/9999) is removed from all the Tracking ID functions.
3. All location types in the freight order, freight booking, and freight unit are changed to "LogisticLocation". You can either download the latest version of extractor or change location types manually in Method GET_LOCATION_TYPE of Class ZCL_GTT_STS_TOOLS. 
4. A new tracked process “TrackingUnit” is introduced in the standard model “gttft1” for you to track the shipments and freight units that have multiple tracked objects in the TM scenario. For example, you can maintain multiple external package IDs on freight units for parcel tracking. The following content is delivered to help you with the implementation: [Implementation Guide for Tracking via Tracking Unit and Reference Document in the TM Scenario](https://github.com/SAP-samples/logistics-business-network-gtt-standardapps-samples/blob/master/lbn-gtt-standard-app/Documents/Implementation%20Guide%20for%20Tracking%20via%20Tracking%20Unit%20and%20Reference%20Document%20in%20the%20TM%20Scenario.pdf).


## May 21st, 2022
1. Fix the issue of not sending "Shipping Type" and "Traffic Direction" to the GTT system after saving the freight order.
2. Fix the timestamp localization issue after synchronizing ETA of the inbound delivery to the ERP system.

## April 23rd, 2022
1. Fix the issue of extractor short dump caused by the missing partner function "Ship-to party" in the outbound delivery.
2. Remove "binary search" in Read Table statement in the Track SO Fulfillment extractor code.

## March 19th, 2022
1. IDOC processing out-of-sequence is fixed when updating the inbound delivery / inbound delivery item / outbound delivery / outbound delivery item after a freight unit is generated.
2. Unit of Measure of sales order items / outbound delivery / outbound delivery items is corrected.


## February 19th, 2022
1.	Track SO Fulfillment and Track PO Fulfillment standard apps are now available for use with Version 2. You can use the two apps to track the fulfilment status of sales orders and purchase orders. The following delivered contents are updated: 
*	[SAP ERP Sample Code Configuration Guide for Fulfillment Tracking Apps.pdf](https://github.com/SAP-samples/logistics-business-network-gtt-standardapps-samples/blob/master/lbn-gtt-standard-app/Documents/SAP%20ERP%20Sample%20Code%20Configuration%20Guide%20for%20Fulfillment%20Tracking%20Apps.pdf)
*	Configuration file for SAP ERP extractors 
*	Sample code for SAP ERP extractors to send the tracked processes and events to SAP Business Network Global Track and Trace (ABAP). 
2.	A new tracked object type "IMO" is added for ocean freight booking.
3.	Issues on reporting "Delay" and "Proof of Pickup" events are fixed.


## December 11th, 2021

The location type in the following tracked processes is changed from "Supplier" / "Customer" to "BusinessPartner":</br>
* InboundDelivery </br>
*	InboundDeliveryItem</br>
*	Shipment.


## November 13th, 2021

1. Retrieve the location types of the freight orders, freight bookings, freight units and actual events from location master data in SAP S/4HANA instead of hard coding them as “LogisticLocation”. 
2. Remove the inboundDeliveryTPs table from the LE-TRA inbound shipment. 
3. Send the inbound delivery number to the shipper reference document table of the LE-TRA inbound shipment. 
4. For the events "Putaway" and "Goods Receipt" of an inbound delivery,  the extraction mode of their quantity is changed from "Delta" to "Full".


## September 18th, 2021
 
1. "Reference Document No." field is added into the "InboundDeliveryItem" tracked process.
2. In the inbound delivery item extractor, inbound delivery items no longer observe inbound deliveries.
3. The actual event "Goods Receipt" in SAP ERP is now tracked by SAP Business Network Global Track and Trace, and extracted into the "InboundDeliveryItem" tracked process.
4. The planned events "Departure" , "Arrival", and "Proof of Delivery" are removed from the "InboundDeliveryItem" tracked process.


## August 21st, 2021
1.	The GTT standard model no longer supports mutual observation between freight orders and freight units. Now only freight units observe freight orders. To achieve this, the following changes are made:</br>
*	Freight orders no longer observe freight units in the freight order extractor </br>
*	Remove the freight unit’s first stop and last stop in the freight order extractor </br>
*	Fill in "additionalMatchKey = TMFU" if the event is propagated from freight units to freight orders and sent to the GTT system via the freight order's actual event extractor.</br>
2.	Remove the leading zero in the document number and tracking ID of inbound delivery orders, inbound delivery items , freight orders, freight units, and shipments.</br>
3. Regarding removing leading zero changes, some adjustments are required for the extractor configurations.</br>
  For more details, please refer to file [SAP ERP Sample Code Configuration Guide for Fulfillment Tracking Apps.pdf](https://github.com/SAP-samples/logistics-business-network-gtt-standardapps-samples/blob/master/lbn-gtt-standard-app/Documents/SAP%20ERP%20Sample%20Code%20Configuration%20Guide%20for%20Fulfillment%20Tracking%20Apps.pdf) (In page 3 from step 2 to step 7).</br>


## July 17th, 2021
Based on the event type and stop sequence, fill in the payload sequence field for the planned events of the inbound delivery, inbound delivery item, LE-TRA shipment, freight order, freight booking and freight unit.</br>

## June 19th, 2021
1. Separately send freight order, freight booking and freight unit’s reference documents to the carrier reference document table and the shipper reference document table in the Track Shipments app according to the document type. Currently we only support the following document types:</br>
* Shipper reference document type: 001(Purchase Order), 58(Inbound Delivery), 114(Sales Order), 73(Outbound Delivery)</br>
* Carrier reference document type: T50(Bill of Lading), T52 (Master Bill of Lading), T55(Master Air Waybill), BN(Consignment Identifier)</br>
2.	The GTT standard model supports mutual observation between shipments and freight units. From the extractor side, the freight unit’s actual events will no longer be sent to the GTT system directly. The current propagation flow is: TM freight unit -> TM freight order -> GTT shipment -> GTT freight unit.</br>
3.	To enable integration with Air Sense, the air freight booking’s flight number is now sent as a tracked object.</br>
4. Remove Created by Business User from the Inbound Delivery Tracked Process.</br>
5. Remove valid-from and valid-to value extracting from SAP ERP and let the GTT system to set the default values.</br>
