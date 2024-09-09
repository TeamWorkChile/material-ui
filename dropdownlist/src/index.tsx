import React, { ReactElement, useEffect, useState } from "react";
import ArrowIcon from "./components/svg/ArrowIcon";
import "./dropdownlist.min.css";
import CloseIcon from "./components/svg/CloseIcon";
import { DARK, LIGHT } from "./dictorionary/theme.dictionary";

interface IDropDownListProps {
  placeholder?: string;
  darkMode?: boolean;
}

export const DropDownList = (
  props: IDropDownListProps
): ReactElement<HTMLSelectElement> => {
  const { placeholder, darkMode } = props;
  const [isOpen, setIsOpen] = useState<boolean>(false);
  
  useEffect(() => {
    setIsOpen(true);
  }, []);

  return (
    <section
      className={`dropdownlist dropdownlist-${!darkMode ? LIGHT : DARK}-mode`}
    >
      <section className="input-dropdownlist">
        <input type="text" readOnly placeholder={placeholder} />
        {isOpen ? (
          <button className="button-close">
            <CloseIcon />
          </button>
        ) : (
          <> </>
        )}
        <button className="button-collapse" onClick={() => setIsOpen(!isOpen)}>
          <ArrowIcon />
        </button>
      </section>
      <span className="label-dropdownlist">Mensaje</span>
    </section>
  );
};
