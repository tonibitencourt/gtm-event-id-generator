___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Event ID for Meta CAPI deduplication",
  "categories": [
    "CONVERSIONS",
    "UTILITY"
  ],
  "brand": {
    "id": "brand_dummy",
    "displayName": "Bitencourt & Co."
  },
  "description": "Returns one event_id per dataLayer event, identical for every tag that fires on that event (Meta Pixel, GA4, server-side). Uses the event_id pushed by the page when present.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "prefix",
    "displayName": "Prefix",
    "simpleValueType": true,
    "defaultValue": "e",
    "help": "Short text placed at the start of every generated id."
  },
  {
    "type": "CHECKBOX",
    "name": "preferDataLayer",
    "checkboxText": "Use the event_id pushed by the page in the same dataLayer event, when present",
    "simpleValueType": true,
    "defaultValue": true
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const copyFromDataLayer = require('copyFromDataLayer');
const templateStorage = require('templateStorage');
const getTimestampMillis = require('getTimestampMillis');
const generateRandom = require('generateRandom');
const makeString = require('makeString');

// 1. The page already created an id for this event: reuse it.
//    Version 1 reads only the current push, so a stale id from an earlier event is never reused.
if (data.preferDataLayer) {
  const pushed = copyFromDataLayer('event_id', 1);
  if (pushed) return makeString(pushed);
}

// 2. One random key per page load, shared by every tag through template storage.
let pageKey = templateStorage.getItem('pageKey');
if (!pageKey) {
  pageKey = makeString(getTimestampMillis()) + '.' + makeString(generateRandom(100000, 999999));
  templateStorage.setItem('pageKey', pageKey);
}

// 3. gtm.uniqueEventId is the same for all tags fired by one dataLayer event.
const uid = copyFromDataLayer('gtm.uniqueEventId');
return (data.prefix || 'e') + '_' + pageKey + '_' + makeString(uid);


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedKeys",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "event_id"
              },
              {
                "type": 1,
                "string": "gtm.uniqueEventId"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_template_storage",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Reuses the event_id pushed by the page
  code: |-
    mock('copyFromDataLayer', (key, version) => key === 'event_id' ? 'abc123' : 7);
    const result = runCode({prefix: 'e', preferDataLayer: true});
    assertThat(result).isEqualTo('abc123');
- name: Same id for two tags on the same event
  code: |-
    mock('copyFromDataLayer', (key, version) => key === 'event_id' ? undefined : 42);
    const a = runCode({prefix: 'e', preferDataLayer: true});
    const b = runCode({prefix: 'e', preferDataLayer: true});
    assertThat(a).isEqualTo(b);
    assertThat(a).contains('_42');


___NOTES___

Created by Bitencourt & Co. Guide: https://lp.bitencourtco.com/kit-tracking/en/guides/meta-capi-deduplication-event-id/
