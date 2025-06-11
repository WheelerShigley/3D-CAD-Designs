    function metricPaperShort(a) = 1000*sqrt(
    (2^-a)/sqrt(2)
);
function metricPaperLong(a) = 1000*sqrt(
    (2^-a)*sqrt(2)
);

module metricPaper(a, height = 0.5, center = true) {
    cube(
        [metricPaperShort(a), metricPaperLong(a), height],
        center
    );
}