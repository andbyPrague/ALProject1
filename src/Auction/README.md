# Auction Integration for Business Central

This extension integrates public auction data into Business Central, displaying information from a public JSON source.

## Features

- List page showing auction data
- Automatic data loading from public JSON source
- Manual refresh capability
- Clickable URLs to view auction details
- Asynchronous data loading to prevent UI blocking

## Prerequisites

- Docker Desktop
- Visual Studio Code with AL Language extension
- Business Central Sandbox container (version 25.0)

## Setup Instructions

1. Clone this repository to your local machine
2. Ensure Docker Desktop is running
3. Open terminal in the project root directory
4. Start the Business Central container:
   ```
   docker-compose up -d
   ```
5. Wait for the container to be fully initialized (this may take a few minutes)
6. Open the project in Visual Studio Code
7. Press F5 to deploy the extension to the container

## Accessing the Auctions Page

1. Open Business Central web client (http://localhost:8080)
2. Search for "Auctions List" in the search bar
3. The page will load automatically and display auction data

## Features Usage

- **View Auction Details**: Click on any URL field to open the auction's original page in your browser
- **Refresh Data**: Click the "Refresh Data" action in the ribbon to manually update the auction data
- **Automatic Updates**: Data is automatically loaded when you open the page

## Technical Details

- The extension uses a temporary table to store auction data
- Data is fetched asynchronously using TaskScheduler to prevent UI blocking
- The source URL is: https://cevd.gov.cz/opendata/drazby/drazby_2025.json

## Limitations and Assumptions

- The extension requires internet access to fetch auction data
- Data is stored temporarily and will be cleared when the session ends
- The JSON structure is assumed to contain 'id', 'nazev', and 'url' fields
- Maximum URL length is 2048 characters
- Maximum Internal Note length is 100 characters
- Auction Number is limited to 20 characters

## Troubleshooting

If you encounter issues:

1. Ensure Docker is running and the container is healthy
2. Check internet connectivity to the data source
3. Verify the JSON endpoint is accessible
4. Check the Event Log in Business Central for any error messages

## Development

The solution uses the following object IDs:
- Table 50150: "Auction Tmp"
- Codeunit 50151: "Auction Management"
- Page 50152: "Auctions List" 
- Page 50162 "Auction Links FactBox"
- Page 50110 "Auction Card"