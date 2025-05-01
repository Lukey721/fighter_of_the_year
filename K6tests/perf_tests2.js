import { check, sleep } from "k6";
import http from "k6/http";

export let options = {
  stages: [
    { duration: "1m", target: 10 },
    { duration: "1m", target: 5 },
    { duration: "20s", target: 0 },
  ],
  thresholds: {
    http_req_duration: ["p(95)<200"], // 95% of requests should be below 200ms
  },
};

export default function () {
  // Replace with your application's URL
  let res = http.get("http://localhost:3005/");

  // Check if the response status is 200
  check(res, { "status is 200": (r) => r.status === 200 });

  // Simulate user think time
  sleep(3);
}