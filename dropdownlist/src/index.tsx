import React, { ReactElement } from "react";
import ArrowIcon from "./components/svg/ArrowIcon";
import "./datepicker.css";

interface IDropDownListProps {
  placeholder?: string;
}

export const DropDownList = (
  props: IDropDownListProps
): ReactElement<HTMLSelectElement> => {
  const { placeholder } = props;

  return (
    <section className="dropdownlist">
      <section className="input-dropdownlist">
        <input type="text" readOnly placeholder={placeholder} />
        <ArrowIcon />
      </section>
    </section>
  );
};