import express from 'express';
import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

const app = express();
const port = 3000;

// GET /r/impression/{missionId}/{publisherId}
app.get('/r/impression/:missionId/:publisherId', async (req, res) => {
    const { missionId, publisherId } = req.params;

    // Log a new impression and check that the mission and publisher exist
    try {
        const mission = await prisma.mission.findUnique({
            where: { id: missionId },
        });

        const publisher = await prisma.publisher.findUnique({
            where: { id: publisherId },
        });

        if (!mission || !publisher) {
            return res.status(404).send('Mission or Publisher not found');
        }

        await prisma.impression.create({
            data: {
                mission_id: missionId,
                publisher_id: publisherId,
            },
        });

        res.send(`Impression logged successfully`);
    } catch (error) {
        res.status(500).send('Internal Server Error');
    }
});

// GET /r/{missionId}/{publisherId}
app.get('/r/:missionId/:publisherId', async (req, res) => {
    const { missionId, publisherId } = req.params;

    // Log a new redirection and check that the mission and publisher exist
    // Then redirect to the mission.application_url with a query parameter apiengagement_id={redirection.token}
    try {
        const mission = await prisma.mission.findUnique({
            where: { id: missionId },
        });

        const publisher = await prisma.publisher.findUnique({
            where: { id: publisherId },
        });

        if (!mission || !publisher) {
            return res.status(404).send('Mission or Publisher not found');
        }

        const redirection = await prisma.redirection.create({
            data: {
                mission_id: missionId,
                publisher_id: publisherId,
            },
        });

        const redirectUrl = `${mission.application_url}?apiengagement_id=${redirection.token}`;
        res.redirect(redirectUrl);
    } catch (error) {
        res.status(500).send('Internal Server Error');
    }
});

// GET - /r/apply?view={token}&mission={missionId}&publisher={publisherId}
app.get('/r/apply', async (req, res) => {
    const { view, mission, publisher } = req.query;
    const redirectionToken = view as string;
    const missionId = mission as string;
    const publisherId = publisher as string;


    // Log a new MissionApplication and check that the mission and publisher exist
    // View is the redirection token ; it's optional
    try {
        const mission = await prisma.mission.findUnique({
            where: { id: missionId },
        });

        const publisher = await prisma.publisher.findUnique({
            where: { id: publisherId },
        });

        const redirection = await prisma.redirection.findUnique({
            where: { token: redirectionToken },
        });

        if (!mission || !publisher) {
            return res.status(404).send('Mission or Publisher not found');
        }

        await prisma.missionApplication.create({
            data: {
                mission_id: missionId,
                publisher_id: publisherId,
                redirection_id: redirection ? redirection.id : null,
            },
        });

        res.send(`Mission Application logged successfully`);
    } catch (error) {
        res.status(500).send('Internal Server Error');
    }
});

app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});