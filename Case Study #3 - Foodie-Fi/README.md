# 🥑 Case Study #3
<p align="center">
<img src="https://github.com/princemayah/8-Week-SQL-Challenge/blob/main/Images/Foodie-Fi.png" align="center" width="400">

## Table of Contents

- [Introduction](#introduction)
- [Case Study Questions](#case-study-questions)
- [Case Study Solutions](#case-study-solutions)

---

## Introduction

Subscription based businesses are super popular and Danny realised that there was a large gap in the market - he wanted to create a new streaming service that only had food related content - something like Netflix but with only cooking shows!

Danny finds a few smart friends to launch his new startup Foodie-Fi in 2020 and started selling monthly and annual subscriptions, giving their customers unlimited on-demand access to exclusive food videos from around the world!

Danny created Foodie-Fi with a data driven mindset and wanted to ensure all future investment decisions and new features were decided using data. This case study focuses on using subscription style digital data to answer important business questions.

---

## Case Study Questions

### A. Customer Journey

Based off the 8 sample customers provided in the sample from the ```subscriptions``` table, write a brief description about each customer’s onboarding journey.

---

### B. Data Analysis Questions

1. How many customers has Foodie-Fi ever had?
2. What is the monthly distribution of ```trial``` plan ```start_date``` values for our dataset - use the start of the month as the group by value
3. What plan ```start_date``` values occur after the year 2020 for our dataset? Show the breakdown by count of events for each ```plan_name```
4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
6. What is the number and percentage of customer plans after their initial free trial?
7. What is the customer count and percentage breakdown of all 5 ```plan_name``` values at ```2020-12-31```?
8. How many customers have upgraded to an annual plan in 2020?
9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

---
### C. Challenge Payment Question

The Foodie-Fi team wants to create a new ```payments``` table for the year 2020 that includes amounts paid by each customer in the ```subscriptions``` table with the following requirements:
  - monthly payments always occur on the same day of month as the original ```start_date``` of any monthly paid plan
  - upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
  - upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period
  - once a customer churns they will no longer make payments

---
### D. Outside The Box Questions 

1. How would you calculate the rate of growth for Foodie-Fi?
2. What key metrics would you recommend Foodie-Fi management to track over time to assess performance of their overall business?
3. What are some key customer journeys or experiences that you would analyse further to improve customer retention?
4. If the Foodie-Fi team were to create an exit survey shown to customers who wish to cancel their subscription, what questions would you include in the survey?
5. What business levers could the Foodie-Fi team use to reduce the customer churn rate? How would you validate the effectiveness of your ideas?

---

## Case Study Solutions

Click here to see the solutions - Incomplete
