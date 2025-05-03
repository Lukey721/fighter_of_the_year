import http from "k6/http";
import { check } from "k6";

export default function () {
  let res = http.get("http://frontend-green:3000/");
  check(res, { "frontend is up": (r) => r.status === 200 });
}