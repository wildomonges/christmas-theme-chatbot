# Welcome to Christmas Theme Chatbot

This project was implemented as part of the [Serverless Holiday Hackathon](https://hackathon.serverless.guru/) organized by [Serverlesss Guru](https://serverlessguru.com/).
At this time the challenge was to implement a *Christmas Theme Chatbot* with the mandatory requeriment to use a *Large Language Model (LLM)* and preference *Serverless services*.


## Table of Contents

- [About the project](#about-the-project)
  - [Features](#features)
  - [Architecture Diagram](#architecture-diagram)
  - [Technologies](#technologies)
  - [Project Structure](#project-structure)
  - [Demo](#demo)
  - [Article](#article)

- [Development](#development)
  - [Local Setup](#local-setup)
  - [Environment Variables](#environment-variables)
  - [Execute Project](#execute-project)
  - [Run tests](#run-test)

- [Deployment](#deployment)
  - [Steps](#steps)

## About the project

This application is a *Chatbot* which allow you to chat with *Santa Claus* about Christmas, Gifts and the Holiday in general.If the child says his name and the gift he would like to get, the system automatically detects the child name and the gift requested and stores into a gifts table, so Santa can check the gifts list to magically generate the gifts :).

### Features
- User Interface to Chat with Santa
- Bedrock invocation to generate a friendly conversation.
- Bedrock invocation to discover child name and gift requested.
- Able to store gift and child information into a database to helps Santa's to remember gifts by child.

### Architecture Diagram

![Architecture Diagram](https://lucid.app/documents/view/f9a7922f-874f-4911-b1ce-51a404b13022)

### Technologies

#### Frontend
- Amplify Hosting
- React
- [UseWebSocket](https://www.npmjs.com/package/react-use-websocket)
- [React Chatbot Kit](https://fredrikoseberg.github.io/react-chatbot-kit-docs/)

#### Backend
- SAM (Serverless Application Model)
- Lambda Function
- Websocket
- SQS
- Dynamodb

### Project Structure

The project is built as *monorepo* just because this represent a MVP. So it is split in two main folders: `frontend` and `backend`.
