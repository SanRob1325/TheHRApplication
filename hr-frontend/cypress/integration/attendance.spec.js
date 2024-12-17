describe('Attendance Management System Tests', () => {

    beforeEach(() =>{

        cy.intercept('GET','/attendances', {fixture: 'attendances.json'}).as('getAttendances');


        cy.visit('http://localhost:3001')
        }

    )
} )