package com.example.demo;

import org.springframework.web.bind.annotation.RestController;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Vector;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@RestController
public class HelloController {

    @RequestMapping("/")
    public String index() {
        return "Hello Jenkins X + Spring Boot! [" + time() + "]";
    }

    @RequestMapping("/highmem")
    @ResponseBody
    public String highmemHandler(
            @RequestParam("count") Long count) {
        Vector<Object> v = new Vector<Object>();
        return "highmem [" + time() + "] - " + highmemResponseGenerator(v, count);
    }

    @RequestMapping("/highmem1")
    public String highmemHandler1(@RequestParam("count") Long count) {
        Vector<Object> v = new Vector<Object>();
        return "highmem1 [" + time() + "] - " + highmemResponseGenerator(v, count);
    }

    @RequestMapping("/highcpu")
    public String highcpuHandler(@RequestParam("count") Long count) {
        return "highcpu [" + time() + "] - " + highcpuResponseGenerator(count);
    }

    @RequestMapping("/highcpu1")
    public String highcpuHandler1(@RequestParam("count") Long count) {
        return "highcpu1 [" + time() + "] - " + highcpuResponseGenerator(count);
    }

    @RequestMapping("/highload")
    public String highloadHandler() {
        return "highload [" + time() + "]";
    }

    @RequestMapping("/lowload")
    public String lowloadHandler() {
        return "lowload [" + time() + "]";
    }

    @RequestMapping("/hc")
    public String hcHandler() {
        return "hc [" + time() + "]";
    }

    private String time() {
        SimpleDateFormat sdf = new SimpleDateFormat("MMM dd,yyyy HH:mm:ss");
        long epoch = System.currentTimeMillis();
        Date resultdate = new Date(epoch);
        return sdf.format(resultdate) + "  epoch = " + epoch;
    }

    private String highmemResponseGenerator(Vector<Object> v, long count) {
        
        // count is in MBs. convert it to bytes
        long countInternal = count * 1024 * 1024;
        
        while (countInternal > 0) {
            if (countInternal > Integer.MAX_VALUE) {
                v.add(new byte[Integer.MAX_VALUE]);
                countInternal = countInternal - Integer.MAX_VALUE;
            } else {
                v.add(new byte[(int) countInternal]);
                break;
            }
        }
        return "Allocated " + count + " MB";
    }

    private String highcpuResponseGenerator(long count) {
        for (int i = 0; i < count; i++) {
            Math.random();
        }
        return "Generated " + count + " random numbers";
    }
}
