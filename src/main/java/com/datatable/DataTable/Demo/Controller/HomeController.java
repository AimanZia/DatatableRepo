package com.datatable.DataTable.Demo.Controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class HomeController {
    @GetMapping("/")
    public String home() {
        return "home"; // Logical view name (matches the JSP name without prefix/suffix)
    }

    @GetMapping("/getData")
    @ResponseBody
    public ResponseEntity<List<Map<String,String>>> welcome() {
        List<Map<String, String>> dataList = new ArrayList<>();

        Map<String, String> row1 = new HashMap<>();
        row1.put("ID", "1");
        row1.put("Name", "John Doe");
        row1.put("Org", "Company A");

        Map<String, String> row2 = new HashMap<>();
        row2.put("ID", "2");
        row2.put("Name", "Jane Doe");
        row2.put("Org", "Company B");

        dataList.add(row1);
        dataList.add(row2);

        return ResponseEntity.ok(dataList);
        
    }
}
