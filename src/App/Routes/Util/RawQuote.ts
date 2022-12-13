export = (app) => {
    const fs = require('fs')

    return {
        path: '/api/RawQuote',
        method: 'GET',
        options: {
            auth: false,
            cors: true,
        },
        handler: async (request, h) => {
            try {
                var json = [
                    { "author": "Anonymous", "quote": "It’s not a bug. It’s an undocumented feature!" },
                    { "author": "Anonymous", "quote": "Software Developer” – An organism that turns caffeine into software" },
                    { "author": "Edsger Dijkstra", "quote": "If debugging is the process of removing software bugs, then programming must be the process of putting them in" },
                    { "author": "Anonymous", "quote": "A user interface is like a joke. If you have to explain it, it’s not that good." },
                    { "author": "Anonymous", "quote": "Things aren’t always #000000 and #FFFFFF" },
                    { "author": "Anonymous", "quote": "My code DOESN’T work, I have no idea why. My code WORKS, I have no idea why." },
                    { "author": "Anonymous", "quote": "Software and cathedrals are much the same — first we build them, then we pray." },
                    { "author": "Vidiu Platon", "quote": "I don’t care if it works on your machine! We are not shipping your machine!" },
                    { "author": "Bill Gates", "quote": "Measuring programming progress by lines of code is like measuring aircraft building progress by weight." },
                    { "author": "Linus Torvalds", "quote": "Talk is cheap. Show me the code." },
                    { "author": "AristiDevs", "quote": "¿A que esperas?, suscríbete." }
                ];
                return json
            } catch (e) {
                console.log(e.stack);
                throw new Error(e.message);
            }
        }
    }
}