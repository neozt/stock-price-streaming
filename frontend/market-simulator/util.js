export {gaussianRandom, sortByVolume};

/**
 * Generates a random number following a normal distribution.
 */
function gaussianRandom(mean, stdev) {
    const u = 1 - Math.random();
    const v = Math.random();
    const z = Math.sqrt(-2.0 * Math.log(u)) * Math.cos(2.0 * Math.PI * v);
    return z * stdev + mean;
}

/**
 * Sorts a list of stocks by their volume in descending order.
 */
function sortByVolume(stockList) {
    return stockList.toSorted((stock1, stock2) => stock2.volume - stock1.volume);
}