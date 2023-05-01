CLASS zpp_class_room DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
    METHODS get_match.
  PRIVATE SECTION.
ENDCLASS.



CLASS zpp_class_room IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    get_match(  ).
  ENDMETHOD.

  METHOD get_match.
    TYPES:
            BEGIN OF ls_pupils,
              name TYPE string,
              positive TYPE STANDARD TABLE OF string WITH DEFAULT KEY,
              negative TYPE STANDARD TABLE OF string WITH DEFAULT KEY,
            END OF ls_pupils,
            ltt_pupils TYPE STANDARD TABLE OF ls_pupils WITH DEFAULT KEY,

            BEGIN OF ls_tables,
              x    TYPE int4,
              y    TYPE int4,
              pair TYPE string,
            END OF ls_tables,
            ltt_tables TYPE STANDARD TABLE OF ls_tables WITH DEFAULT KEY,

            BEGIN OF ls_pupils_positive,
              name     TYPE string,
              positive TYPE string,
            END OF ls_pupils_positive,
            ltt_pupils_positive TYPE STANDARD TABLE OF ls_pupils_positive WITH DEFAULT KEY,

            BEGIN OF ls_positive_unique_pair,
                name     TYPE string,
                positive TYPE string,
                place   TYPE int4,
            END OF ls_positive_unique_pair,
            ltt_positive_unique_pair TYPE STANDARD TABLE OF ls_positive_unique_pair WITH DEFAULT KEY.

    DATA:
            lt_pupils               TYPE ltt_pupils,
            lt_tables               TYPE ltt_tables,
            lt_pupils_positive      TYPE ltt_pupils_positive,
            lt_positive_unique_pair TYPE ltt_positive_unique_pair,
            lv_place                TYPE int4
            .


    lt_pupils = VALUE #(
      (
        name = 'A'
        positive = VALUE #(
                           ( |B| )
                           ( |E| )
                          )
        negative = VALUE #(
                           ( |F| )
                           ( |D| )
                           ( |C| )
                          )
      )
      (
        name = 'B'
        positive = VALUE #(
                           ( |A| )
                           ( |E| )
                          )
        negative = VALUE #(
                           ( |D| )
                          )
      )
      (
        name = 'C'
        positive = VALUE #(
                           ( |E| )
                          )
        negative = VALUE #(
                           ( |A| )
                           ( |F| )
                           ( |D| )
                          )
      )
      (
        name = 'D'
        positive = VALUE #( )
        negative = VALUE #(
                           ( |A| )
                           ( |B| )
                           ( |C| )
                           ( |E| )
                           ( |F| )
                          )
      )
      (
        name = 'E'
        positive = VALUE #(
                           ( |B| )
                           ( |A| )
                           ( |C| )
                           ( |E| )
                          )
        negative = VALUE #(
                           ( |D| )
                          )
      )
      (
        name = 'F'
        positive = VALUE #(
                           ( |E| )
                          )
        negative = VALUE #(
                           ( |A| )
                           ( |C| )
                           ( |D| )
                          )
      )
    ).

    lt_tables = VALUE #(
      ( x = 1  y = 1 pair = || )
      ( x = 2  y = 1 pair = || )
      ( x = 3  y = 1 pair = || )
      ( x = 4  y = 1 pair = || )
      ( x = 5  y = 1 pair = || )
      ( x = 1  y = 2 pair = || )
      ( x = 2  y = 2 pair = || )
      ( x = 3  y = 2 pair = || )
      ( x = 4  y = 2 pair = || )
      ( x = 5  y = 2 pair = || )
      ( x = 1  y = 3 pair = || )
      ( x = 2  y = 3 pair = || )
      ( x = 3  y = 3 pair = || )
      ( x = 4  y = 3 pair = || )
      ( x = 5  y = 3 pair = || )

    ).

    LOOP AT lt_pupils ASSIGNING FIELD-SYMBOL(<fs_pupils>).
      LOOP AT <fs_pupils>-positive ASSIGNING FIELD-SYMBOL(<fs_positive>).
        APPEND INITIAL LINE TO lt_pupils_positive ASSIGNING FIELD-SYMBOL(<fs_pupils_positive>).
            <fs_pupils_positive>-name     = <fs_pupils>-name.
            <fs_pupils_positive>-positive = <fs_positive>.
      ENDLOOP.
    ENDLOOP.

    lt_positive_unique_pair = CORRESPONDING #( lt_pupils_positive ).

    LOOP AT lt_positive_unique_pair ASSIGNING FIELD-SYMBOL(<fs_positive_unique_pair>) GROUP BY <fs_positive_unique_pair>-name.
      lv_place = 0.
      LOOP AT GROUP <fs_positive_unique_pair> ASSIGNING FIELD-SYMBOL(<fs_pupils_positive_unique>) .
        lv_place = lv_place + 1.
        <fs_pupils_positive_unique>-place = lv_place.
      ENDLOOP.
    ENDLOOP.

    LOOP AT lt_pupils_positive INTO DATA(ls_pupils_positive).
      LOOP AT  lt_positive_unique_pair ASSIGNING <fs_pupils_positive_unique>
                                         WHERE name = ls_pupils_positive-positive AND positive = ls_pupils_positive-name
                                         .
        DATA(lv_index) = sy-tabix.

        lt_pupils_positive[ lv_index ]-name     = ||.
        lt_pupils_positive[ lv_index ]-positive = ||.

        lt_positive_unique_pair[ lv_index ]-name     = ||.
        lt_positive_unique_pair[ lv_index ]-positive = ||.
        lt_positive_unique_pair[ lv_index ]-place    = 0.


      ENDLOOP.
    ENDLOOP.









*    LOOP AT lt_pupils_positive INTO DATA(ls_pupils_positive).
*
*      LOOP AT lt_positive_unique_pair INTO DATA(ls_positive_unique_pair) WHERE positive = ls_pupils_positive-name OR
*                                                                               name     = ls_pupils_positive-positive OR
*                                                                               ( name = ls_pupils_positive-name AND place <> 1 ).
*        DATA(lv_index) = sy-tabix.
*        lt_positive_unique_pair[
*                                 lv_index
*                               ]-place = 0.
**        lt_positive_unique_pair[
**                                 name     = ls_pupils_positive-name
**                                 positive = ls_pupils_positive-positive
**                               ]-name = ||.
**        lt_positive_unique_pair[
**                                 name     = ls_pupils_positive-name
**                                 positive = ls_pupils_positive-positive
**                               ]-positive = ||.
*
*        IF line_exists( lt_pupils_positive[ name     = ls_positive_unique_pair-name
*                                            positive = ls_positive_unique_pair-positive ] ).
*          lt_pupils_positive[
*                              name     = ls_positive_unique_pair-name
*                              positive = ls_positive_unique_pair-positive
*                            ]-name = ||.
*        ENDIF.
*
*      ENDLOOP.
*    ENDLOOP.

    DELETE lt_positive_unique_pair WHERE place = 0.

  ENDMETHOD.

ENDCLASS.
