import { createBrowserRouter } from "react-router-dom";
import Home from "../components/home"; // Ensure the path is correct
import Login from "../components/Login";
import PanchayathDashboard from "../components/PanchayathDashboard";
import DashboardLayout from "../layout/dashboardLayout";
import Dashboard from "../components/dashboard";
import UsageChart from "../components/chart";
import AddUser from "../components/addUser";
import EventDetails from "../components/event";
import Member from "../components/addmember";
import EventPage from "../components/event";
import NotificationPage from "../components/notification";
import ViewComplaints from "../components/viewComplaints";
import ViewAllUsers from "../components/viewUser";
import ViewMembers from "../components/viewMember";
import ViewHomeSpotId from "../components/viewHomeid";
import SearchHomeSpotId from "../components/searchHomeId";


export const routes = createBrowserRouter([
  {
    path: "/",
    element: <Home />, 
  },
  {
    path:"/login",
    element:<Login />,
  },
  
  
  {
    path: "/dashboard",
    element: <DashboardLayout/>,
    children:[
      {
        path:'',
        element: <Dashboard/>
      },
      {
        path:'chart',
        element: <UsageChart/>
      },
      {
        path:'add-user',
        element: <AddUser/>
      },
      {
        path:'view-request',
        element: <ViewComplaints/>
      },
      // {
      //   path: "view-request",
      //   element: </>
      // },
      {
        path:'view-userdetails',
        element: <ViewAllUsers/>
      },
      {
        path:'add-events',
        element: <EventPage/>
      },
      ,{
        path:'add-member',
        element: <Member/>
      },
      {
        path:'view-notifications',
        element: <NotificationPage/>
      },
      {
        path:'view-member',
        element: <ViewMembers/>
      },
      {
        path:'view-homespotId',
        element: <ViewHomeSpotId/>
      },
      {
        path:'search-homespotId',
        element: <SearchHomeSpotId/>
      },
    ]
  },

  
]);
