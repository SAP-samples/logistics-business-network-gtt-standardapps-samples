# Fulfillment Tracking Apps for SAP Business Network Global Track and Trace 

## What's New
### Nov 12th, 2022
1. To support tracking without carrier onboarding, the Standard Carrier Alpha Code (SCAC) of a carrier can be retrieved.
2. For the outbound delivery and the outbound delivery item, remove the configuration check of "Define Transportation-Relevance of Delivery Documents" in control parameters and planned events.
3. In the scenario "Maintain Tracked Objects on Freight Order/Freight Booking", the issue of missing planned “Departure” and “Arrival” events in the freight unit is fixed.

For previous release information, see [What's New for Fulfillment Tracking Apps](https://github.wdf.sap.corp/TrackAndTrace/GTT-V2-Standard-Apps/blob/test/lbn-gtt-standard-app/Documents/What's%20New%20for%20Fulfillment%20Tracking%20Apps.md).


## Description
You can find the sample code for SAP ERP extractors that are necessary to integrate SAP ERP with [SAP Business Network Global Track and Trace ](https://help.sap.com/viewer/product/SAP_LBN_GTT_OPTION/LBN/en-US?task=discover_task) in this project. You can either implement the sample code or customize it to fit your needs. The delivered contents include: 

* Sample code for SAP ERP extractors to send the tracked processes and events to SAP Business Network Global Track and Trace (ABAP)
* Configuration file for SAP ERP extractors

 
## Requirements

* Make sure that you have met the requirements for the product version mentioned in the [Prerequisites](https://help.sap.com/docs/SAP_LBN_GTT_OPTION/d0802f41861a4f81a3610d873fdcf148/c9f7baf5f6e14be4ba9045786961de14.html) section of Appendix one: Connect to SAP ERP in Administration Guide for Version 2. You can find this guide at http://help.sap.com/gtt. 
* The ABAP codes on Github to support fulfillment tracking apps for SAP Business Network Global Track and Trace shall be implemented in SAP S/4HANA 1909 SP03 on premise or higher. Please note that the codes are not validated in its lower version or other ECC series of products, so you might need to do further adaptation work or build your own extractor.

## Download and Installation
Click the link below to find the detailed installation guide. You can also find the guide in the “Document” folder.
* [SAP ERP Sample Code Configuration Guide for Fulfillment Tracking Apps.pdf](https://github.com/SAP-samples/logistics-business-network-gtt-standardapps-samples/blob/master/lbn-gtt-standard-app/Documents/SAP%20ERP%20Sample%20Code%20Configuration%20Guide%20for%20Fulfillment%20Tracking%20Apps.pdf) </br>


## Known Issues
If multiple IDOC payloads are generated at the same time or in a very short period of time in SAP ERP, these payloads might enter the GTT system in disorder. This might cause update errors in some situations.

## How to Obtain Support
The project is provided "as-is", with no expected support. </br>
If your issue is concerned with SAP Business Network Global Track and Trace, log your incident in SAP support system with component “SBN-LBN-GTT-TSH” for Track Shipments app, “SBN-LBN-GTT-MIA” for Monitor Inbound ASNs app, "SBN-LBN-GTT-TSF" for Track SO Fulfillment app and "SBN-LBN-GTT-TPF" for Track PO Fulfillment app. 

For additional support, [ask a question in SAP Community](https://answers.sap.com/questions/ask.html?additionalTagId=73555000100800000602).

## License
Copyright (c) 2020 SAP SE or an SAP affiliate company. All rights reserved. This project is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](https://github.com/SAP-samples/logistics-business-network-gtt-samples/blob/master/LICENSES/Apache-2.0.txt) file.

## Reuse Status
[![REUSE status](https://api.reuse.software/badge/github.com/SAP-samples/logistics-business-network-gtt-standardapps-samples)](https://api.reuse.software/info/github.com/SAP-samples/logistics-business-network-gtt-standardapps-samples)
