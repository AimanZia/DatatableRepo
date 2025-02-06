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

    <style>
        /* Hide the default DataTables length selection */
        .dataTables_length {
            display: none;
        }
    </style>
</head>
<body>

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

            // Fetch data from the controller
            $.ajax({
                url: "getData",  // URL to your controller
                type: "GET",
                dataType: "json",
                success: function (data) {
                    console.log("Received Data:", data); // DEBUG: Check received JSON

                    if (data.length > 0) {
                        let columns = Object.keys(data[0]); // Extract column names
                        console.log("Detected Columns:", columns); // DEBUG: Check extracted columns

                        let tableHeader = $("#tableHeader");
                        let columnSelect = $("#columnSelect");

                        // **Clear previous headers & dropdown options**
                        //tableHeader.empty();
                        columnSelect.empty().append(`<option value="">Select Column</option>`);

                        // **Ensure columns exist**
                        if (columns.length === 0) {
                            console.error("No columns detected in JSON!");
                            return;
                        }

                        // **Create headers dynamically**
                        //tableHeader.empty(); // Clear previous headers

                        // **Dynamically Create Table Headers**
                        columns.forEach(column => {
                            $("<th>").text(column).appendTo(tableHeader); // Properly append headers
                            $("<option>").val(column).text(column).appendTo(columnSelect); // Add to dropdown
                        });

                        console.log("Table Headers Updated:", tableHeader.html()); // Debug log
                        console.log("Select Options Updated:", columnSelect.html()); // Debug log


                        // **Initialize DataTable AFTER headers are set**
                        let table = $('#dynamicTable').DataTable({
                            "data": data,
                            "columns": columns.map(col => ({ "data": col })),
                            "dom": "rtip",  // Hide "Show 10, 20, etc."
                            "destroy": true  // Ensure table is reset if reloaded
                        });

                        // **Search based on selected column**
                        $('#columnSearch').on('keyup', function () {
                            let selectedColumn = $('#columnSelect').val();
                            if (selectedColumn) {
                                table.column(columns.indexOf(selectedColumn)).search(this.value).draw();
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
        });
    </script>

</body>
</html>
