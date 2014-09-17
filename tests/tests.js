
exports.defineAutoTests = function () {
    
    var fail = function (done) {
        expect(true).toBe(false);
        done();
    },
    succeed = function (done) {
        expect(true).toBe(true);
        done();
    };

    describe('Geocoder (navigator.geocoder)', function () {

        it("geocoder.spec.1 should exist", function () {
            expect(navigator.geocoder).toBeDefined();
        });

    });

};
