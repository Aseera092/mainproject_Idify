import React from "react";
import { Bar } from "react-chartjs-2";
import { Chart as ChartJS, CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend } from "chart.js";

// Register Chart.js components
ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend);

const UsageChart = () => {
  const data = {
    labels: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
    datasets: [
      {
        label: "Website Visits",
        data: [120, 200, 150, 220, 300, 250, 400], // Example data
        backgroundColor: "rgba(10, 4, 99, 0.6)",
        borderColor: "rgb(13, 3, 81)",
        borderWidth: 1,
      },
    ],
  };

  const options = {
    responsive: true,
    plugins: {
      legend: { display: true },
      title: { display: true, text: "Website Usage Statistics (Weekly)" },
    },
  };

  return (
    <div className="card mt-4 p-3">
      <h5 className="card-title">Website Usage</h5>
      <Bar data={data} options={options} />
    </div>
  );
};

export default UsageChart;
