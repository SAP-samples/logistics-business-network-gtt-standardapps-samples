# Fulfillment Tracking Apps for SAP Business Network Global Track and Trace 

## What's New
### August 16th, 2025
Minor enhancements are made to improve the system performance when there is a large number of freight units or freight unit items.

For previous release information, see [What's New for Fulfillment Tracking Apps](https://github.com/SAP-samples/logistics-business-network-gtt-standardapps-samples/blob/test/lbn-gtt-standard-app/Documents/What's%20New%20for%20Fulfillment%20Tracking%20Apps.md).

## Description
You can find the following contents in this project:
* Sample codes for SAP ERP extractors to send the tracked processes and events to SAP Business Network Global Track and Trace (ABAP)
* Configuration file for SAP ERP extractors

The sample codes are not provided as part of standard delivery, but only as an example to show you how to set up the SAP ERP extractors for use with fulfillment tracking apps. They are not standard codes and you can customize them for your business scenarios. 

You should determine what documents with certain condition need to be sent to SAP Business Network Global Track and Trace for tracking. You don't need to send unnecessary ones. For example, if you only need the sales order, then you don't have to implement the purchase order.

 
## Requirements

* Make sure that you have met the requirements for the product version mentioned in the [Prerequisites](https://help.sap.com/docs/business-network-global-track-and-trace/a01652f35ace458c91e9c915ba052b64/6af8c81399a042168b19a3b74f5fb7bb.html) chapter of How to Send Documents from SAP S/4HANA to SAP Business Network Global Track and Trace. You can find this guide at http://help.sap.com/gtt. 
* The ABAP codes on Github to support fulfillment tracking apps for SAP Business Network Global Track and Trace shall be implemented in systems from SAP S/4HANA 1909 SP03 on premise to SAP S/4HANA 2022 on premise. Please note that the codes are not validated in its lower version or other ECC series of products, so you might need to do further adaptation work or build your own extractor.

## Download and Installation
Click the link below to find the detailed installation guide. You can also find the guide in the “Document” folder.
* [Sample Code Configuration Guide for Integration with SAP Business Network Global Track and Trace.pdf](https://github.com/SAP-samples/logistics-business-network-gtt-standardapps-samples/blob/test/lbn-gtt-standard-app/Documents/Sample%20Code%20Configuration%20Guide%20for%20Integration%20with%20SAP%20Business%20Network%20Global%20Track%20and%20Trace.pdf) </br>


## Known Issues
You cannot implement SAP Event Management (SAP EM) and sample codes for SAP Business Network Global Track and Trace at the same time, because some functions might be missing.

If multiple IDOC payloads are generated at the same time or in a very short period of time in SAP ERP, these payloads might enter the GTT system in disorder. This might cause update errors in some situations.

## How to Obtain Support
The project is provided "as-is", with no expected support. </br>
If your issue is concerned with SAP Business Network Global Track and Trace, log your incident in SAP support system with component “SBN-LBN-GTT-TSH” for Track Shipments app, “SBN-LBN-GTT-MIA” for Monitor Inbound ASNs app, "SBN-LBN-GTT-TSF" for Track SO Fulfillment app, "SBN-LBN-GTT-TPF" for Track PO Fulfillment app and "SBN-LBN-GTT-MOD" for Monitor Outbound Deliveries app. 

For additional support, [ask a question in SAP Community](https://answers.sap.com/questions/ask.html?additionalTagId=73555000100800000602).

## License
Copyright (c) 2020 SAP SE or an SAP affiliate company. All rights reserved. This project is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](https://github.com/SAP-samples/logistics-business-network-gtt-samples/blob/master/LICENSES/Apache-2.0.txt) file.

## Reuse Status
[![REUSE status](https://api.reuse.software/badge/github.com/SAP-samples/logistics-business-network-gtt-standardapps-samples)](https://api.reuse.software/info/github.com/SAP-samples/logistics-business-network-gtt-standardapps-samples)
