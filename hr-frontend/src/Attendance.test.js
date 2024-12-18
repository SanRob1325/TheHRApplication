import React from "react";
import {render,screen,fireEvent,waitFor} from "@testing-libary/react"
import Attendance from "./Attendance";
import Attendances from "./Attendance";
import axios from "axios";

jest.mock("../api",() => require("../_mocks_/axios"));


describe("Attendance Component",() => {
    beforeEach(() => {
        jest.clearAllMocks();
    });

    test("renders the Attendance page", async () => {
        axios.get.mockResolvedValueOnce({
            data: [
                {id: 1, employee: "Jack Jones", status: "Present", date: "2024-12-11"}
            ],
        });

        render(<Attendances />);

        expect(await screen.findByText("Jack Jones")).toBeInTheDocument();
        expect(screen.getByText("Present")).toBeInTheDocument();
        expect(screen.getByText("2024-12-11")).toBeInTheDocument();
    });

    test("adds a new attendance", async () => {
        axios.post.mockResolvedValueOnce({
            data: [
                {id: 2, employee: "Jane Smith", status: "Absent", date: "2024-12-16"}
            ]
        });

        render(<Attendances/>);

        fireEvent.click(screen.getByText("Add Attendance"));

        fireEvent.change(screen.getByPlaceholderText("Employee"), {
            target: { value: "2024-12-18"},
        });
        fireEvent.click(screen.getByText("Save"));

        expect(await screen.findByText("Jane Smith")).toBeInDocument();
        expect(screen.getByText("Absent")).toBeInTheDocument();
        expect(screen.getByText("2024-12-16")).toBeInTheDocument();
    });
});


