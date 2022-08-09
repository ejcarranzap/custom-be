export = (app) => {
    return {
        method: 'GET',
        path: '/api/jwttest',
        config: { auth: 'jwt' },
        handler: (request, h) => {
            return 'You are access to protected route'
        }
    }
}