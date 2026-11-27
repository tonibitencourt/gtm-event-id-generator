# Event ID for Meta CAPI deduplication (GTM variable template)

A Google Tag Manager custom variable that returns **one `event_id` per dataLayer event**, identical for every tag that fires on that event.

Meta merges a browser event (Pixel) with its server copy (Conversions API) only when both carry the same `event_name` and the same `event_id`. A variable that generates a random id each time it is read gives every tag a different id, and Meta counts the conversion twice. This template avoids that.

## How it works

1. If the page pushed an `event_id` in the same `dataLayer.push`, it returns that value (recommended: create the id on the page).
2. Otherwise it builds `prefix_<page key>_<gtm.uniqueEventId>`:
   - the page key is created once per page load and shared through template storage;
   - `gtm.uniqueEventId` is the same for all tags fired by one dataLayer event.

## Use

1. In GTM: **Templates → Variable Templates → New → ⋮ → Import**, choose `template.tpl`, save.
2. **Variables → New**, type *Event ID for Meta CAPI deduplication*. Name it `Event ID`.
3. Meta Pixel tag: pass `{{Event ID}}` as the event ID (`eventID`).
4. GA4 / server-side tag: send `{{Event ID}}` as the `event_id` parameter, and map it to the Conversions API `event_id` in the server container.
5. Check in Events Manager → Test events: each conversion should appear from **Browser** and **Server** with the same id, and be marked as deduplicated.

## Learn more

- Guide: [Meta Conversions API deduplication: why your cost per conversion just halved](https://lp.bitencourtco.com/kit-tracking/en/guides/meta-capi-deduplication-event-id/?utm_source=github&utm_medium=referral&utm_campaign=gtm-event-id)
- Free field guide: [13 Silent Tracking Failures](https://tonibitencourt.gumroad.com/l/13-silent-tracking-failures?utm_source=github&utm_medium=referral&utm_campaign=gtm-event-id)
- Full setup, from the ad click to HubSpot deal stages back to Meta: [4-Layer Tracking Kit](https://tonibitencourt.gumroad.com/l/4-layer-tracking?utm_source=github&utm_medium=referral&utm_campaign=gtm-event-id)
- Agencies and freelancers: recommend the kit to clients and earn 50% per sale, [affiliate program](https://lp.bitencourtco.com/kit-tracking/en/affiliates/?utm_source=github&utm_medium=referral&utm_campaign=gtm-event-id)

Apache-2.0 License · Bitencourt & Co.
