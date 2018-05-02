$(document).on('turbolinks:load',function() {
	// fill page
	fillPage();

	if ($('.pagination').length) {
		// non-mobile
		$('#content').scroll(function() {
			paginate($('#content'));
		});

		// mobile
		$(window).scroll(function() {
			paginate($(window));
		});
	}
});

function paginate(sender) {
	var url = $('.pagination .next_page').attr('href');
	if (url && sender.scrollTop() > $(document).height() - sender.height() - 50) {
		$('.pagination').text("Loading...").addClass('d-block');
		return $.getScript(url);
	}
}

function fillPage() {
	if ($('.pagination').length && !$('#content').isVerticallyScrollable() && !$(window).isVerticallyScrollable()) { 
		var url = $('.pagination .next_page').attr('href');
		$('.pagination').text("Loading...").addClass('d-block');
		return $.getScript(url, function() { fillPage(); });
	}
}


(function($) {
	/**
	 * Detects whether element can be scrolled vertically.
	 * @this jQuery
	 * @return {boolean}
	 */
	$.fn.isVerticallyScrollable = function() {

		if (this.scrollTop()) {
			// Element is already scrolled, so it is scrollable
			return true;
		} else {
			// Test by actually scrolling
			this.scrollTop(1);

			if (this.scrollTop()) {
				// Scroll back
				this.scrollTop(0);
				return true;
			}
		}

		return false;
	};

	$.extend($.expr.pseudos || $.expr[ ":" ], {
		"vertically-scrollable": function(a, i, m) {
			return $(a).isVerticallyScrollable();
		}
	});
})(jQuery);
