---
title: Delve into prometheus 
date: 2024-11-06 20:17:00
tags: [monitoring, prometheus]
---

## 1. Introduction to Time Series Data

**TL;DR**

Time series data is a sequence of data points collected or recorded at specific time intervals, typically used to track changes or trends over time.

**Data Schema**

- Structure: `identifier -> (t0, v0), (t1, v1), (t2, v2), ...`

**Data in Prometheus**

- Format: `<metric_name>{<label_name>=<label_value>, ...}`

Example of a typical set of series identifiers (data model):

```json

{ "__name__": "http_requests_total", "pod": "example-pod", "job": "example-job", "path": "/api/v1/resource", "status": "200", "method": "GET"} @1430000000 94355
{ "__name__": "http_requests_total", "pod": "example-pod", "job": "example-job", "path": "/api/v1/resource", "status": "200", "method": "PUT"} @1435000000 94355
{ "__name__": "http_requests_total", "pod": "example-pod", "job": "example-job", "path": "/api/v1/resource", "status": "200", "method": "POST"} @1439999999 94355
```

**Components:**

- **Key: Series**
    - **Metric Name:** `__name__`
    - **Labels:**
        
        ```json
        {"pod": "example-pod", "job": "example-job", "path": "/api/v1/resource", "status": "200", "method": "GET"}
        ```
        
    - **Timestamp:** Recorded time of the sample
- **Value:** Sample value

**How to Query:**

- Example Queries:
    - `__name__="http_requests_total"` - Selects all series belonging to the `http_requests_total` metric
    - `method="PUT|POST"` - Selects all series where the method is either PUT or POST

<!-- more -->

## 2. Challenges in Time Series Storage

### Write Operations

- Write operations need to efficiently handle high volumes of time-stamped data across multiple series.

### Read Operations

- Querying time series data is often more complex than writing, as it requires accessing specific time ranges and filtering by multiple labels.

### The Fundamental Problem

1. **Storage Issues:**
    - **IDE Drives**: Slower mechanical rotation limits data speed.
    - **SSD Drives**: **Issues** with write amplification:
        - Small (e.g., 4KB) modifications can result in larger (e.g., 256KB) deletions, affecting longevity and efficiency.
    - **Complex Queries**: Time series queries can cause random reads, reducing performance.
2. **Ideal Read Pattern:** Batch reads for efficiency.
3. **Ideal Write Pattern:** Sequential writes are optimal, benefiting from disk structure.

TODO: Define "write amplification"

## 3. Prometheus Time Series Storage Solutions

- **File per Time Series**: Prometheus stores each time series in a separate file, batching 1KiB chunks in memory to optimize performance.

TODO: Add visual representation (diagram) of Prometheus storage model.

**Challenges ("Dark Side") in Prometheus:**

- High disk usage in production
- High memory consumption for indexing
- Series churn due to frequent label changes in high-frequency data

## 4. Detailed Components of TSDB in Prometheus

### Overview of the File Structure

At the highest level, the Prometheus TSDB (Time Series Database) has a well-defined file structure that organizes time series data for efficient storage and querying. Below is an example of the directory tree:

```bash
data
├── blocks
│   ├── 01FG7C0Q0G3QZ8N1KZ4P1MXY7V
│   │   ├── chunks
│   │   │   ├── 000001
│   │   │   ├── 000002
│   │   │   └── ...
│   │   ├── index
│   │   │   ├── index.db
│   │   │   └── ...
│   │   ├── meta.json
│   │   └── tombstones
│   │       └── tombstones.json
│   └── 01FG7C0Q0G3QZ8N1KZ4P1MXY7W
│       ├── chunks
│       ├── index
│       ├── meta.json
│       └── tombstones
├── chunks_head
│   ├── 000001
│   ├── 000002
│   └── ...
├── index
│   ├── index.db
│   └── ...
├── meta.json
├── lock
└── wal
    ├── 00000001
    ├── 00000002
    └── ...

```

### Explanation of Concepts

- **blocks/**:
    - **chunks/**: Stores separated chunks of time series data. These files represent compressed segments of data for efficient storage and retrieval.
    - **index/**: Contains index files like `index.db`, which are used to accelerate query performance by allowing quick lookup of data points.
    - **meta.json**: Metadata files that describe each block, including time ranges and configuration details.
    - **tombstones/**: Holds information about deleted time series. The `tombstones.json` file records data marked for deletion to manage space and maintain consistency.
- **chunks_head**: Stores unpacked time series data that resides in memory. Data in this section has not yet been persisted to the `blocks/` directory.
- **index/**: A global index directory containing files for quick querying, such as `index.db`, which enables efficient data retrieval across multiple series.
- **meta.json**: The global metadata file recording the overall status and configuration information of the TSDB.
- **lock**: A lock file used to prevent multiple Prometheus instances from accessing the same data folder simultaneously, ensuring data consistency and integrity.
- **wal (Write-Ahead Log)**: Stores the most recent write operations to prevent data loss in case of an unexpected crash or power failure. These log files are named sequentially, e.g., `00000001`, `00000002`.

**Key Notes**:

- Data is persisted to disk every 2 hours.
- WAL (Write-Ahead Log) is crucial for data recovery.
- The 2-hour block structure allows efficient querying within a specific time range.

### Diving Into the Details

### Block Structure: A Mini Database

Each block in the Prometheus storage system can be seen as a mini database that stores time series data in a structured format. The organization of blocks allows for efficient compression, indexing, and retrieval.

### Benefits of the New Design

By restructuring time series storage, Prometheus has improved read and write performance:

1. **Earlier Design**:
    - Each time series was stored in an individual file.
    - Querying multiple time series required accessing many separate files, leading to inefficiencies.
2. **New Design**:
    - Aggregated data is stored in larger block files, reducing the number of I/O operations.
    - Queries involving multiple time series can access contiguous data segments.

### Data Operations Overview

- **Hot Spot Data**:
    - Stored in memory for faster access.
    - Frequently queried data remains in the `chunks_head` section.
- **Chunk Size**:
    - Optimized for efficient storage and quick access.

**Thoughts on Data Management**:
In computer science, simply storing raw data and processing it in large batches is typically less efficient than using an index combined with raw data. A well-designed data model with smart indexing can greatly enhance the performance and usability of software systems, showcasing the elegance of software architecture.

**Transition from Chunks Head to Blocks**:
Data in `chunks_head` is periodically moved to persistent blocks to reduce memory pressure and ensure data is durable.

## 5. In-Depth: Key Components in Prometheus Storage

### Memory-Mapped Files (mmap)

Prometheus uses memory-mapped files to efficiently access large blocks of data stored on disk, bridging the gap between memory and storage.

### Write-Ahead Log (WAL)

- **Purpose**: Ensures data durability by recording recent writes before they are persisted to block storage. This approach is common in columnar databases to provide high availability (HA) and protect against data loss.
- **How It Works**: Recent data writes are stored sequentially in WAL files, enabling efficient recovery after a failure.

### Block Compression Techniques

Prometheus employs various compression techniques within its blocks to minimize storage space while maintaining fast data retrieval. The block structure optimizes storage without compromising query speed.

**Indexing and Query Optimization**:

- The index files allow Prometheus to quickly locate samples matching specific label sets.
- **Inverted Indexing**: Prometheus uses an inverted index to match label-value pairs efficiently, accelerating join operations and complex queries.