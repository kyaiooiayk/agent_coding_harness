---
type: Reference
title: HTTP Connection Heat
description: Long-lived service processes (agent worker, LLM microservice) hold an internal HTTP connection pool via the vendor SDK (groq, openai, deepgram). After several minutes of no traffic the API server...
tags: [reference, llm, api, connections]
timestamp: 2026-07-12T00:00:00Z
---

# HTTP Connection Heat

## What is this about?
- Long-lived service processes (agent worker, LLM microservice) hold an internal HTTP connection pool via the vendor SDK (groq, openai, deepgram). After several minutes of no traffic the API server closes its end of that connection. The pool still holds the dead socket. The next request silently retries on a fresh socket, paying a full TCP + TLS + HTTP/2 handshake penalty before the actual API call can begin.
- From the caller's perspective the reply is simply slow. There is no error, no log line, and no retry visible at the application level.
***

## When does this happen?
The trigger is idle time between calls, not a restart. Typical server-side idle timeouts:

| Provider | Approximate idle timeout |
|---|---|
| Groq | ~5 min |
| OpenAI | ~5–10 min |
| Deepgram (REST) | ~5 min |

Any voice or chat turn that follows a pause longer than these windows will incur the reconnect cost.

***

## Which connections are affected?
Only connections whose underlying HTTP client is **reused across calls from the same process**.

| Connection | Reused across calls? | Can go cold? |
|---|---|---|
| Groq LLM (`ChatGroq` → `groq` SDK → httpx pool) | Yes | Yes |
| Deepgram TTS (`livekit-plugins-deepgram`, aura-2 REST) | Yes | Yes |
| OpenAI LLM / TTS (`ChatOpenAI` → `openai` SDK → httpx pool) | Yes | Yes |
| Deepgram STT (WebSocket opened per utterance) | No — new socket per speech event | No |
| Internal microservice calls (`async with httpx.AsyncClient(...)`) | No — new client per request | No |
***

## Detection strategy
The connection state is not exposed by httpx or the vendor SDKs. The only reliable detection method is time-based: if the gap between the last completed call and the current call exceeds the known server-side idle timeout, the connection is cold. This is not implemented as it would more noise than benefit.
***

