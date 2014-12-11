// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require moment
//= require bootstrap-datetimepicker
//= require select2

$(document).ready(function() {
  $(".birthdatepicker").datetimepicker({
    pickTime: false,
    maxDate: new Date(),
    defaultDate: "1/1/1990"
  });

  $(".datepicker").datetimepicker({
    pickTime: false
  });

  $("#donation_date").datetimepicker({
    pickTime: false,
    maxDate: new Date(),
    defaultDate: new Date()
  });

  var donor_select2 = $("input[id='donation_donor_id']").select2({
    allowClear: true,
    minimumInputLength: 2,
    id: function(result) {
      return result.donor.id
    },
    placeholder: "Search for donor by name",
    ajax: {
      url: "/donors",
      dataType: "json",
      quietMillis: 200,
      data: function (term, page) {
        return {
          q: { full_name_cont: term },
          page: page,
        }
      },
      results: function(data, page) {
        return {
          results: data
        }
      }
    },
    formatResult: function(result) {
      return "<div class='select2-user-result'>" + result.donor.full_name + "</div>";
    },
    formatSelection: function(result) {
      if(result.donor) {
        $.ajax({
          url: "/donors/" + result.donor.id + "/show_partial",
          type: "GET",
          dataType: "html"
        })
        .always(function(data) {
          $("#donation_donor").html(data);
        });

        return result.donor.full_name
      } else {
        return result.term;
      }
    },
    dropdownCssClass: "bigdrop",
    initSelection : function (element, callback) {
      var elementText = $(element).attr("data-init-text");
      callback({"term":elementText});
    }
  }).data("select2");

  var volunteer_select2 = $("input[id='donation_person_id']").select2({
    allowClear: true,
    minimumInputLength: 2,
    id: function(result) {
      return result.person.id
    },
    placeholder: "Search for volunteer by email",
    ajax: {
      url: "/people",
      dataType: "json",
      quietMillis: 200,
      data: function (term, page) {
        return {
          q: { email_cont: term },
          page: page,
        }
      },
      results: function(data, page) {
        return {
          results: data
        }
      }
    },
    formatResult: function(result) {
      return "<div class='select2-user-result'>" + result.person.email + "</div>";
    },
    formatSelection: function(result) {
      if(result.person) {
        return result.person.email
      } else {
        return result.term;
      }
    },
    dropdownCssClass: "bigdrop",
    initSelection : function (element, callback) {
      var elementText = $(element).attr("data-init-text");
      callback({"term":elementText});
    }
  }).data("select2");

  var item_select2 = $("input[id='donation_item_id']").select2({
    allowClear: true,
    minimumInputLength: 2,
    id: function(result) {
      return result.item.id
    },
    placeholder: "Search for item by name",
    ajax: {
      url: "/items",
      dataType: "json",
      quietMillis: 200,
      data: function (term, page) {
        return {
          q: { name_cont: term },
          page: page,
        }
      },
      results: function(data, page) {
        return {
          results: data
        }
      }
    },
    formatResult: function(result) {
      return "<div class='select2-user-result'>" + result.item.identifier + "</div>";
    },
    formatSelection: function(result) {
      if(result.item) {
        return result.item.identifier
      } else {
        return result.term;
      }
    },
    dropdownCssClass: "bigdrop",
    initSelection : function (element, callback) {
      var elementText = $(element).attr("data-init-text");
      callback({"term":elementText});
    }
  }).data("select2");

  $(".donation_quantity").addClass("hidden");
  $(".donation_item_id").addClass("hidden");


  $("body").on("change", "#donation_type_cd", function() {
    var type_field = $(this);

    if(type_field.val() == "cash") {
      $(".donation_quantity").addClass("hidden");
      $(".donation_item_id").addClass("hidden");
      $(".donation_amount").removeClass("hidden");

    } else if(type_field.val() == "kind") {
      $(".donation_quantity").removeClass("hidden");
      $(".donation_item_id").removeClass("hidden");
      $(".donation_amount").addClass("hidden");
    }
  })
});
