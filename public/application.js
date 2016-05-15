$(document).ready(function() {
    $('#answer_form').on('submit', function(e) {
        e.preventDefault()
        var $this = $(this)
        var processing = false;
        if (!processing) {
            processing = true;
            $.ajax({
                url: $this.attr('action'),
                type: $this.attr('method'),
                data: $this.serialize(),
                success: function (data) {
                    $("#alert_answer").remove()
                    var close = $("<a href='#' class='close' data-dismiss='alert' aria-label='close'>&times;</a>");
                    var alert_div = $('<div>', {
                        id: "alert_answer",
                        class: data["correct_or_not"],
                    }).text(data["answer"]);
                    alert_div.append(close);
                    alert_div.insertBefore(".question");
                    processing = false;
                },
                error: function (error) {
                    console.log(error);
                }
            });
        }
        else{
            alert('not so fast!')
        }
    });
});


