# Mia – AI Voice Assistant

A conversational AI voice assistant that answers real telephone calls, interacts naturally with callers, and retrieves information from a private knowledge source using custom API tools.

Built as a hands-on AI engineering project to explore voice AI, tool calling, Python backend development, AWS serverless infrastructure, and end-to-end testing.

## Features

- **Real telephone conversations:** Receives incoming calls through a Canadian Twilio phone number.
- **Natural voice interaction:** Uses ElevenLabs for conversational AI, speech processing, and voice generation.
- **Custom AI personality:** Supports configurable greetings, conversational behaviour, and response styles.
- **Private knowledge retrieval:** Retrieves information from structured JSON records through a custom Python API.
- **Name ambiguity handling:** Distinguishes between people with similar names and requests clarification.
- **Authenticated API access:** Uses API-key authentication and AWS Secrets Manager.
- **Serverless deployment:** Runs backend services on AWS Lambda and API Gateway.
- **Infrastructure as Code:** Uses Terraform to provision AWS resources.

## Architecture

```text
Caller
  |
  v
Twilio Phone Number
  |
  v
ElevenLabs Conversational AI Agent
  |
  | Custom Tool: lookup_friend
  v
Amazon API Gateway
  |
  v
AWS Lambda (Python / FastAPI)
  |
  +--> AWS Secrets Manager (API Authentication)
  |
  +--> Amazon S3 (Private Knowledge Data)
  |
  v
Structured JSON Lookup
  |
  v
ElevenLabs Generates Spoken Response
  |
  v
Caller
```

## Technology Stack

| Component | Technology |
|---|---|
| Programming language | Python |
| Backend framework | FastAPI |
| Voice AI | ElevenLabs |
| Telephony | Twilio |
| Cloud platform | AWS |
| Serverless compute | AWS Lambda |
| API management | Amazon API Gateway |
| Private data storage | Amazon S3 |
| Secret management | AWS Secrets Manager |
| Infrastructure as Code | Terraform |
| Version control | Git and GitHub |

## How It Works

1. A caller dials the Twilio telephone number.
2. Twilio connects the call to the ElevenLabs conversational AI agent.
3. ElevenLabs processes the caller's speech and generates responses.
4. When private information is required, the agent invokes the `lookup_friend` custom tool.
5. API Gateway routes the authenticated request to AWS Lambda.
6. The Python backend searches structured knowledge records and returns a result.
7. The AI uses the retrieved information to respond naturally to the caller.

## Testing and Quality Engineering

The project was validated through local API testing, AWS Lambda testing, and live telephone conversations.

Testing included:

- API authentication and unauthorized request handling.
- Successful lookup of known records.
- Handling of ambiguous names.
- Handling of unknown names.
- End-to-end integration between Twilio, ElevenLabs, API Gateway, and AWS Lambda.
- Voice configuration and published agent version verification.
- Live conversational testing with multiple knowledge queries.

An integration issue involving unpublished agent configuration was identified, corrected, and retested successfully.

## Privacy and Security

The public source code does not include private knowledge records, API credentials, or Terraform state.

Sensitive configuration is excluded using `.gitignore`. API authentication uses environment variables for local development and AWS Secrets Manager for deployed execution.

Real caller information and conversation logs are not included in this repository.

## Potential Business Applications

This architecture can be adapted for business voice assistants that:

- Answer frequently asked questions.
- Explain services and operating hours.
- Collect customer inquiries.
- Retrieve information from business knowledge sources.
- Integrate with appointment scheduling and CRM systems.

Appointment booking, CRM integration, and human-call transfer are potential future enhancements, not current features.

## Project Status

**Working prototype:** Successfully tested with live telephone calls and custom knowledge retrieval.

This repository documents the backend and infrastructure. The ElevenLabs agent and Twilio number are configured separately.

## Author

Personal AI Engineering and Quality Engineering portfolio project.