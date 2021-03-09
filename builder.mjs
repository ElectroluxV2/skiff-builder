import { spawnSync } from 'child_process';
import fs from 'fs';

const updateEvery = 1000;
const repository = 'https://github.com/ElectroluxV2/skiff.git';
const buildDirectory = 'build';
const beforeBuildCommand = 'npm i';
const buildCommand = 'npm run prod';
const afterBuildCommand = 'sh export.sh';


const loop = () => {
    // Clone repository if not exists
    if (!fs.existsSync(buildDirectory)) {
        console.log('Cloning repository')
        const { error: cloneError } = spawnSync('git', ['clone', repository, buildDirectory]);
        if (!!cloneError) {
            console.warn(`Error occurred during "git clone ${repository} ${buildDirectory}" command:`, cloneError);
            return;
        }
    } else {
        // Only update
        console.log('Pull repository')
        const { error: pullError } = spawnSync('git', ['pull', 'origin', 'main'], {
            cwd: `${buildDirectory}`
        });

        if (!!pullError) {
            console.warn(`Error occurred during "git pull origin main" command:`, pullError);
            return;
        }
    }

    // Run before build command
    const beforeBuildCommandArray = beforeBuildCommand.split(' ');
    console.log('Before build command');
    const { error: beforeBuildError } = spawnSync(beforeBuildCommandArray.shift(), beforeBuildCommandArray, {
        cwd: `${buildDirectory}`
    });

    if (!!beforeBuildError) {
        console.warn(`Error occurred during "${beforeBuildCommand}" command:`, beforeBuildError);
        return;
    }

    // Run build command
    const buildCommandArray = buildCommand.split(' ');
    console.log('Build command');
    const { error: buildError } = spawnSync(buildCommandArray.shift(), buildCommandArray, {
        cwd: `${buildDirectory}`
    });

    if (!!buildError) {
        console.warn(`Error occurred during "${buildCommand}" command:`, buildError);
        return;
    }

    // Run after build command
    const afterBuildCommandArray = afterBuildCommand.split(' ');
    console.log('After build command')
    const { error: afterBuildCommandError } = spawnSync(afterBuildCommandArray.shift(), afterBuildCommandArray);

    if (!!afterBuildCommandError) {
        console.warn(`Error occurred during "${afterBuildCommand}" command:`, afterBuildCommandError);
    }

    console.log(`Waiting ${updateEvery} ms to next update`);
};

setInterval(loop, updateEvery);
