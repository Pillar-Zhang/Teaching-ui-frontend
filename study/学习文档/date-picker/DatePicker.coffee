F.enableDatePicker = ($input, options)->
    options = options || {}
    $input.prop('readonly', true)
    $input.click (e)->
        value = $input.val()
        now = if value then moment(value, "YYYY-MM-DD") else moment()
        thisYear = now.year()
        thisMonth = now.month()
        thisDate = now.date()
        startYear = options.startYear || thisYear - 10
        endYear = options.endYear || thisYear + 10
        $datePicker = $ FT.DatePicker({thisYear, thisMonth, thisDate,
            startYear, endYear})
        $datePicker.appendTo($('body'))

        $selectYear = $datePicker.find('.select-year')
        $selectMonth = $datePicker.find('.select-month')

        renderMonthDays = ->
            renderingDays = []
            year = parseInt($selectYear.val())
            month = parseInt($selectMonth.val())
            firstDayOfMonth = moment({y: year, M: month, d: 1})
            weekDay = firstDayOfMonth.day()
            weekDay = 7 if weekDay == 0 # Sunday 从前改到后
            lastMonthRestDays = weekDay - 1
            if lastMonthRestDays
                lastMonthLastDate = firstDayOfMonth.clone().subtract(1, 'months')
                    .endOf("month").date()
                for i in [1..lastMonthRestDays]
                    renderingDays.push(lastMonthLastDate - (lastMonthRestDays - i))

            daysInMonth = firstDayOfMonth.daysInMonth()
            for i in [1..daysInMonth]
                renderingDays.push(i)

            nextMonthAheadDays = 7 - (lastMonthRestDays + daysInMonth) % 7
            if nextMonthAheadDays != 7
                renderingDays.push(i) for i in [1..nextMonthAheadDays]

            $table = $('tbody.date', $datePicker).empty()
            classString = "last-month"
            for i in [0...renderingDays.length]
                if i % 7 == 0
                    $tr = $('<tr>').appendTo($table)
                d = renderingDays[i]
                if classString == "last-month" && d == 1
                    classString = "this-month"
                else if classString == "this-month" && d == 1
                    classString = "next-month"

                $td = $('<td>', {html: d, class: classString}).appendTo($tr)
                if classString == "this-month" && d == thisDate
                    $td.addClass('today')

        $selectYear.on 'change', renderMonthDays
        $selectMonth.on 'change', renderMonthDays

        $datePicker.find('a.prev-month').click ->
            m = parseInt($selectMonth.val())
            if m == 0
                $selectYear.val(parseInt($selectYear.val()) - 1)
                $selectMonth.val(11)
            else
                $selectMonth.val(m - 1)
            renderMonthDays()

        $datePicker.find('a.next-month').click ->
            m = parseInt($selectMonth.val())
            if m == 11
                $selectYear.val(parseInt($selectYear.val()) + 1)
                $selectMonth.val(0)
            else
                $selectMonth.val(m + 1)
            renderMonthDays()

        $datePicker.on 'click', 'td', ->
            $this = $(this)
            d = $this.text()
            year = parseInt($selectYear.val())
            month = parseInt($selectMonth.val())
            mm = if $this.hasClass('this-month')
                moment({y: year, M: month, d: d})
            else if $this.hasClass('next-month')
                moment({y: year, M: month, d: 1}).add(1, 'M').date(d)
            else if $this.hasClass('last-month')
                moment({y: year, M: month, d: 1}).add(-1, 'M').date(d)

            $input.val(mm.format("YYYY-MM-DD"))
            $datePicker.remove()

        $datePicker.find('.cancel').click -> $datePicker.remove()

        renderMonthDays()

