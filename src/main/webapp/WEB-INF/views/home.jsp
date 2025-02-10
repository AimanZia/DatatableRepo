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
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.25/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/1.7.1/css/buttons.dataTables.min.css">

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
    });
    </script>

</body>
</html>
