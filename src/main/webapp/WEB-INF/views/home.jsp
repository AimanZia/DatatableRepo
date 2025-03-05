<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dynamic DataTable with Column-Based Search</title>

    <!-- Include jQuery and DataTables CSS/JS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.25/css/jquery.dataTables.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.25/js/jquery.dataTables.min.js"></script>
    <%-- <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script> --%>
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.25/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/1.7.1/css/buttons.dataTables.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">


    <!-- jQuery and DataTables -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.25/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/1.7.1/js/dataTables.buttons.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/1.7.1/js/buttons.html5.min.js"></script>


    <style>
        /* Hide the default DataTables length selection */
        .dataTables_length {
            display: none;
        }
        #progressbar-container {
            width: 50%;
            margin: 50px auto;
            text-align: center;
        }
        .progress-wrapper {
            position: relative;
            width: 100%;
        }
        #progressbar {
            width: 100%;
            height: 30px;
            background-color: #ddd; /* Light background */
            border-radius: 5px;
            position: relative;
        }
        .progress-fill {
            height: 100%;
            width: 0%; /* Dynamic width */
            background-color: red; /* Red progress color */
            border-radius: 5px;
            position: absolute;
        }
        .progress-text {
            position: absolute;
            width: 100%;
            text-align: center;
            color: white;
            font-weight: bold;
            line-height: 30px;
            z-index: 1;
        }
    </style>
</head>
<body>
    <div id="progressbar-container">
        <h2>Dynamic Progress Bar</h2>
        <div class="progress-wrapper">
            <div id="progressbar">
                <div class="progress-fill"></div>
                <div class="progress-text">0 / 10</div>
            </div>
        </div>
        <br>
        <button id="loadProgress">Load Maturity Score</button>
    </div>

    <div class="container mt-4">
        <h2 class="text-center">Cloud Providers</h2>
        <div id="cloudCarousel" class="carousel slide" data-bs-ride="carousel">
            <div class="carousel-inner">

                <!-- Azure -->
                <div class="carousel-item active" data-region="Global" data-services="Compute, Storage">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/a/a8/Microsoft_Azure_Logo.svg" class="d-block" alt="Azure">
                    <div class="carousel-caption">
                        <h5>Microsoft Azure</h5>
                    </div>
                </div>

                <!-- Google Cloud -->
                <div class="carousel-item" data-region="Global" data-services="Compute, AI, ML">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/5/51/Google_Cloud_logo.svg" class="d-block" alt="GCP">
                    <div class="carousel-caption">
                        <h5>Google Cloud</h5>
                    </div>
                </div>

                <!-- AWS -->
                <div class="carousel-item" data-region="Global" data-services="Compute, Database">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/9/93/Amazon_Web_Services_Logo.svg" class="d-block" alt="AWS">
                    <div class="carousel-caption">
                        <h5>Amazon Web Services</h5>
                    </div>
                </div>

                <!-- Alibaba Cloud -->
                <div class="carousel-item" data-region="China" data-services="Compute, CDN">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/f/fa/Alibaba_Cloud_logo.svg" class="d-block" alt="Alibaba Cloud">
                    <div class="carousel-caption">
                        <h5>Alibaba Cloud</h5>
                    </div>
                </div>

            </div>

            <!-- Controls -->
            <button class="carousel-control-prev" type="button" data-bs-target="#cloudCarousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#cloudCarousel" data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Next</span>
            </button>

            <!-- Indicators -->
            <div class="carousel-indicators">
                <button type="button" data-bs-target="#cloudCarousel" data-bs-slide-to="0" class="active"></button>
                <button type="button" data-bs-target="#cloudCarousel" data-bs-slide-to="1"></button>
                <button type="button" data-bs-target="#cloudCarousel" data-bs-slide-to="2"></button>
                <button type="button" data-bs-target="#cloudCarousel" data-bs-slide-to="3"></button>
            </div>
        </div>
    </div>

    <!-- Bootstrap & jQuery -->
    <%-- <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> --%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Include jQuery UI (Make sure this is after jQuery) -->
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>



    <label for="columnSelect">Search By:</label>
    <select id="columnSelect">
        <option value="">Select Column</option>
    </select>
    <input type="text" id="columnSearch" placeholder="Enter search text">

    <table id="dynamicTable" class="display" style="width:100%">
        <thead>
            <tr id="tableHeader"></tr>
        </thead>
        <tbody></tbody>
    </table>

    <script>
        $(document).ready(function () {
        console.log("Fetching data from server...");

        $.ajax({
            url: "/getData",  // Your backend API URL
            type: "GET",
            dataType: "json",
            success: function (data) {
                console.log("Received Data:", data);

                if (data.length > 0) {
                    let columns = Object.keys(data[0]); // Extract column names
                    console.log("Detected Columns:", columns);

                    let tableHeader = $("#tableHeader");
                    let columnSelect = $("#columnSelect");

                    // **Clear previous headers & dropdown options**
                    tableHeader.empty();
                    columnSelect.empty().append(`<option value="">Search in all columns</option>`);

                    if (columns.length === 0) {
                        console.error("No columns detected in JSON!");
                        return;
                    }

                    // **Dynamically Create Table Headers**
                    columns.forEach(column => {
                        $("<th>").text(column).appendTo(tableHeader);
                        $("<option>").val(column).text(column).appendTo(columnSelect);
                    });

                    console.log("Table Headers Updated:", tableHeader.html());
                    console.log("Select Options Updated:", columnSelect.html());

                    // **Initialize DataTable with Disabled Sorting & Export Buttons**
                    let table = $('#dynamicTable').DataTable({
                        "data": data,
                        "columns": columns.map(col => ({ "data": col })),
                        "ordering": false,   // ❌ Disable sorting on all columns
                        "searching": true,   // ✅ Enable global search
                        "dom": 'Bfrtip',     // ✅ Add export buttons
                        "buttons": [
                            {
                                extend: 'excel',
                                text: 'Export to Excel',
                                title: 'Exported Data'
                            }
                        ],
                        "destroy": true  // Ensure table resets if reloaded
                    });

                    // **Search based on selected column OR whole table**
                    $('#columnSearch').on('keyup', function () {
                        let selectedColumn = $('#columnSelect').val();
                        let searchValue = this.value;

                        if (selectedColumn) {
                            // Search only in selected column
                            table.column(columns.indexOf(selectedColumn)).search(searchValue).draw();
                        } else {
                            // Search in all columns
                            table.search(searchValue).draw();
                        }
                    });
                } else {
                    console.error("Empty data received!");
                }
            },
            error: function (xhr, status, error) {
                console.error("AJAX Error:", status, error);
                alert("Error fetching data from server.");
            }
        });

        // $("#progressbar").progressbar({
        //         value: 0
        //     });

            // Simulated API call
            function fetchMaturityScore() {
                $(".progress-fill").css({"width": "100%", "background-color": "gray"});
                $(".progress-text").text("Loading...");
                $.ajax({
                    url: "/getMaturityScore", // Replace with actual API
                    type: "GET",
                    dataType: "json",
                    success: function(response) {
                        var score = response.maturity_score; // Get the score from the API
                        updateProgressBar(score);
                    },
                    error: function() {
                        $(".progress-text").text("Error fetching data");
                        $(".progress-fill").css("background-color", "darkred");
                    }
                });
            }

            function updateProgressBar(score) {
                var percentage = (score / 10) * 100; // Convert to percentage
                $(".progress-fill").css("width", percentage + "%");
                $(".progress-text").text(score + " / 10");
            }

            // Load data on button click
            $("#loadProgress").click(function() {
                fetchMaturityScore();
            });
        
    });
    </script>

</body>
</html>
