function get(url) {
    var result2 = zdjl.requestUrl({
        url: url,
        method: 'GET',
    });
    return JSON.parse(result2.body);
}

userIds = "7411187002";
var url = 'https://dungvip.xyz/api/check.php?userIds=' + userIds;
var data = get(url);

var trangthai = data.userPresences[0].userPresenceType;

// Kiểm tra trạng thái của người dùng và thông báo
while (trangthai == 2) {
    zdjl.toast("Đang online");
    // Có thể cần đợi một khoảng thời gian trước khi kiểm tra lại
    sleep(5000); // Dừng 5 giây trước khi kiểm tra lại
    data = get(url); // Lấy dữ liệu mới
    trangthai = data.userPresences[0].userPresenceType;
}
